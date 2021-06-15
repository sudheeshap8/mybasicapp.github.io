FROM node:12.16.3

WORKDIR /my-code

ENV PORT 9000

COPY package.json /my-code/package.json

RUN npm install

COPY . /my-code

CMD ["npm", "run", "docker-serve"]

FROM jenkins/jenkins:2.289.1-lts-jdk11
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
  ca-certificates curl gnupg2 \
  software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.24.6 docker-workflow:1.26"
