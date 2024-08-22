#!/bin/bash
sudo yum install git docker nodejs
sudo npm install -g aws-cdk
git pull https://github.com/srobroek/one-observability-demo/PetAdoptions/cdk/pet_stack/
sudo service docker start
cd one-observability-demo
npm install



export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 3600")
AWS_REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
EKS_ADMIN_ARN=arn:aws:iam::$ACCOUNT_ID:role/Admin
#update the EKS ADMIN role to studio participant
CONSOLE_ROLE_ARN=$EKS_ADMIN_ARN

sudo cdk deploy --context admin_role=$EKS_ADMIN_ARN Services --context dashboard_role_arn=$CONSOLE_ROLE_ARN --require-approval never
export NO_PREBUILT_LAMBDA=1  && sudo cdk deploy Applications --require-approval never