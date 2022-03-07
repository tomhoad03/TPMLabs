export TPM2TOOLS_TCTI=mssim:host=localhost,port=2321
tpm2_startup -c

tpm2_flushcontext -t

# create a new endorsment key
tpm2_createek -G rsa -c ek.ctx
#tpm2_readpublic -c ek.ctx

tpm2_flushcontext -t

# create a key that only the admin can use
tpm2_createprimary -C o -c primary.ctx
tpm2_create -G rsa -u rsa.pub -r rsa.priv -C ek.ctx

tpm2_flushcontext -t

# load the signing key
tpm2_load -C ek.ctx -u rsa.pub -r rsa.priv -c rsa.ctx

tpm2_flushcontext -t

# sign the data and verify
tpm2_sign -c rsa.ctx -g sha256 -o sig.rssa message.dat
tpm2_verifysignature -c rsa.ctx -g sha256 -s sig.rssa -m message.dat

tpm2_clear
