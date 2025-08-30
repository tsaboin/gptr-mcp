FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better Docker layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set environment variables for Docker
ENV MCP_TRANSPORT=streamable-http
ENV DOCKER_CONTAINER=true
ENV PYTHONUNBUFFERED=1

# Expose the port
EXPOSE 8111

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://0.0.0.0:8111/health || exit 1

# Run the server
CMD ["python", "server.py"] 
