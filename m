Return-Path: <linux-kernel-owner+w=401wt.eu-S1945921AbXBBPE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945921AbXBBPE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945926AbXBBPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:04:29 -0500
Received: from rk.rkuhn.info ([88.198.164.84]:41536 "EHLO mailhost.rkuhn.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945921AbXBBPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:04:28 -0500
In-Reply-To: <3d8471ca0702020548n9455f4fre8c4ceea3f070a51@mail.gmail.com>
References: <200701272152.11087.vda.linux@googlemail.com> <87bqkhuqpp.fsf@tantale.fifi.org> <200702020000.40524.vda.linux@googlemail.com> <87abzxbhau.fsf@tantale.fifi.org> <E0CFA8EB-F706-49E8-A1D1-7BAF19C8D271@e18.physik.tu-muenchen.de> <3d8471ca0702020548n9455f4fre8c4ceea3f070a51@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-138-995408851"
Message-Id: <24DAE20A-F4CC-4A8F-902A-2A73D0DA2EB1@e18.physik.tu-muenchen.de>
Cc: "Philippe Troin" <phil@fifi.org>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
From: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
Date: Fri, 2 Feb 2007 16:04:13 +0100
To: "Guillaume Chazarain" <guichaz@gmail.com>
Content-Transfer-Encoding: 7bit
X-Pgp-Agent: GPGMail 1.1.2 (Tiger)
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-138-995408851
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-137-995408828; protocol="application/pkcs7-signature"


--Apple-Mail-137-995408828
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hi Guillaume!

On 2 Feb 2007, at 14:48, Guillaume Chazarain wrote:

> 2007/2/2, Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>:
>
>> That's a bug, right?
>
> No, if you want something like: (echo toto; date; echo titi) > file
> to work in your shell, you'll be happy to have the seek position
> shared in the processes.
>
As a naive user I'd probably expect that each of the above adds to  
the output, which perfectly fits the O_APPEND flag (to be set by the  
shell, of course).

The immediate point was about the flags, though, and having  
O_NONBLOCK on or off certainly is a _design_ choice when writing a  
program. If I remove O_NONBLOCK, I have a right to expect that I/O  
functions do not return EAGAIN!

Ciao,
                     Roland

--
TU Muenchen, Physik-Department E18, James-Franck-Str., 85748 Garching
Telefon 089/289-12575; Telefax 089/289-12570
--
CERN office: 892-1-D23 phone: +41 22 7676540 mobile: +41 76 487 4482
--
Any society that would give up a little liberty to gain a little
security will deserve neither and lose both.  - Benjamin Franklin
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GS/CS/M/MU d-(++) s:+ a-> C+++ UL++++ P+++ L+++ E(+) W+ !N K- w--- M 
+ !V Y+
PGP++ t+(++) 5 R+ tv-- b+ DI++ e+++>++++ h---- y+++
------END GEEK CODE BLOCK------



--Apple-Mail-137-995408828
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINxTCCBi4w
ggUWoAMCAQICCmEPqkwAAAAAAAMwDQYJKoZIhvcNAQEFBQAwQTESMBAGCgmSJomT8ixkARkWAmNo
MRQwEgYKCZImiZPyLGQBGRYEY2VybjEVMBMGA1UEAxMMQ0VSTiBSb290IENBMB4XDTA2MTAwMzA5
MzYxM1oXDTE2MTAwMzA5NDYxM1owWTESMBAGCgmSJomT8ixkARkWAmNoMRQwEgYKCZImiZPyLGQB
GRYEY2VybjEtMCsGA1UEAxMkQ0VSTiBUcnVzdGVkIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwdFGqthhWlgUOSZ6C6hReNEVGzbjf2IQgxo7
/rOfOQHZH3krQPQ37fqFroEr46PrruymZ/U+QAzmESZQ4Z+nCfBhm7cEi0TIhihHd4cEPaPxawGR
T9Ck7BBk9za8TUljF6c/JodnIcmIrpbazEbSAS1KEXwETHDsTrQ7lJ+6SzDP4/oOwrHrgJx+tKsm
gOsFSbBEK4OYx1UYQpYS9OJQk2Sc0q4a/SCSu+xbN8ppmgV3WFytN8NW20n3NpCCWYPzo9rXmPRA
7a/c6mf+RV5gPCnUqeW6KUvix5kz9+X8/4SQV/fU12OPdRvtkqcC+PpiePK7bjMLQJEYwvchJrSz
AwIDAQABo4IDDjCCAwowDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUmMyS0EYwNoyw7ZgNclGp
R0zdviEwCwYDVR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgECMCMGCSsGAQQBgjcVAgQWBBT/Rljl
vgfrVK8GmAaYe+TbiXbJ7DBRBgNVHSAESjBIMEYGCisGAQQBYAoCAQEwODA2BggrBgEFBQcCARYq
aHR0cDovL2NhLmNlcm4uY2gvY2EvY3JsL3BvbGljeS9jcC1jcHMucGRmMBkGCSsGAQQBgjcUAgQM
HgoAUwB1AGIAQwBBMB8GA1UdIwQYMBaAFJgK9+w+7FnWHa2ZvLUBPt7spudQMIH8BgNVHR8EgfQw
gfEwge6ggeuggeiGLWh0dHA6Ly9jYS5jZXJuLmNoL2NhL2NybC9DRVJOJTIwUm9vdCUyMENBLmNy
bIaBtmxkYXA6Ly8vQ049Q0VSTiUyMFJvb3QlMjBDQSxDTj1jZXJucm9vdGNhLENOPUNEUCxDTj1Q
dWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWNl
cm4sREM9Y2g/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERp
c3RyaWJ1dGlvblBvaW50MIIBBAYIKwYBBQUHAQEEgfcwgfQwRAYIKwYBBQUHMAKGOGh0dHA6Ly9j
YS5jZXJuLmNoL2NhL2NybC9jZXJucm9vdGNhX0NFUk4lMjBSb290JTIwQ0EuY3J0MIGrBggrBgEF
BQcwAoaBnmxkYXA6Ly8vQ049Q0VSTiUyMFJvb3QlMjBDQSxDTj1BSUEsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1jZXJuLERDPWNoP2NB
Q2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MA0GCSqG
SIb3DQEBBQUAA4IBAQAfEzvOeYohKndmJqnVdiCqZ38tSBxOOPsKUHW4UY1jBfYMXbnZ9keFQFlK
/g5X4aZPNBEHXw0eKpQVsMhEPWQrvx8T/f7GwtU+JNQhkgK9tnezmHxYzWgEC9MXZhfYzFSwMIF6
kSKllmUTnN35uF1EnT8+64daje+yEVcpmM34p8Fw125/WpKnRmwNp0YkUk6uMti6Y6vOTHttzIN5
P6elGoat8sadMqrVnaMNzG8hGUvSkYivYBs7msAPuwmXgLvIkXWPW+MDFs+x5Kzx75ZHv3c2WoKg
UxL5KZH9QqiR7t8P6YBfYW6SpzyGRi4QHN/iOLhXZ06R6aPljLEOn41JMIIHjzCCBnegAwIBAgIK
chmBHgACAAACZjANBgkqhkiG9w0BAQUFADBZMRIwEAYKCZImiZPyLGQBGRYCY2gxFDASBgoJkiaJ
k/IsZAEZFgRjZXJuMS0wKwYDVQQDEyRDRVJOIFRydXN0ZWQgQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkwHhcNMDYxMTA5MTMwMjIzWhcNMDcxMTA5MTMwMjIzWjCBiTESMBAGCgmSJomT8ixkARkWAmNo
MRQwEgYKCZImiZPyLGQBGRYEY2VybjEWMBQGA1UECxMNT3JnYW5pYyBVbml0czEOMAwGA1UECxMF
VXNlcnMxDjAMBgNVBAMTBXJrdWhuMQ8wDQYDVQQDEwY1Nzg4NDcxFDASBgNVBAMTC1JvbGFuZCBL
dWhuMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsxeKSFlg3DexXFatyivnuM4Cny5T
wPQ2PfpxmEPxycXaGHlM+gVtSYRYll8nl/sJ/+etmw5H7cwxWSX1n2TLphDsxWIg9LDfRPgWJdfY
NtT3SclmEiwOAE934HmbuZ08X/xRmnz0D3Df2fbDCVQLRra3u1ZLGvzhT835Wx7+uKme/GPlZdPZ
QUBKN/xRlMyywvIBJtdoHmTDv93B4o+yaR+JjT5h0YOLS+2GA9vbS6YdXw38+pche/D3SD20zZP8
K78f3YWltka/PpEqq4JGvtlOdrr4BZ3i9/UusblVBGZJFTTznIRtUvPW29D9DTngutH6JQQazurR
MePYBzsjVQIDAQABo4IEJjCCBCIwHQYDVR0OBBYEFP67uXXCxYdJS7PG+73J0TsKDmhQMB8GA1Ud
IwQYMBaAFJjMktBGMDaMsO2YDXJRqUdM3b4hMIIBNAYDVR0fBIIBKzCCAScwggEjoIIBH6CCARuG
R2h0dHA6Ly9jYS5jZXJuLmNoL2NhL2NybC9DRVJOJTIwVHJ1c3RlZCUyMENlcnRpZmljYXRpb24l
MjBBdXRob3JpdHkuY3JshoHPbGRhcDovLy9DTj1DRVJOJTIwVHJ1c3RlZCUyMENlcnRpZmljYXRp
b24lMjBBdXRob3JpdHksQ049Y2VybnBraTAxLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2
aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWNlcm4sREM9Y2g/Y2VydGlmaWNh
dGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50MIIB
RAYIKwYBBQUHAQEEggE2MIIBMjBoBggrBgEFBQcwAoZcaHR0cDovL2NhLmNlcm4uY2gvY2EvY3Js
L2Nlcm5wa2kwMS5jZXJuLmNoX0NFUk4lMjBUcnVzdGVkJTIwQ2VydGlmaWNhdGlvbiUyMEF1dGhv
cml0eSgyKS5jcnQwgcUGCCsGAQUFBzAChoG4bGRhcDovLy9DTj1DRVJOJTIwVHJ1c3RlZCUyMENl
cnRpZmljYXRpb24lMjBBdXRob3JpdHksQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2Vz
LENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9Y2VybixEQz1jaD9jQUNlcnRpZmljYXRl
P2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTAMBgNVHRMBAf8EAjAAMA4G
A1UdDwEB/wQEAwIFoDA9BgkrBgEEAYI3FQcEMDAuBiYrBgEEAYI3FQiDvdAJgu2NDYbtiyuB3vU3
hYDQYh6Fv7oDhMTMTAIBZAIBBTApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQB
gjcKAwQwNQYJKwYBBAGCNxUKBCgwJjAKBggrBgEFBQcDAjAKBggrBgEFBQcDBDAMBgorBgEEAYI3
CgMEMFsGA1UdEQRUMFKgLwYKKwYBBAGCNxQCA6AhDB9ya3VobkBlMTgucGh5c2lrLnR1LW11ZW5j
aGVuLmRlgR9ya3VobkBlMTgucGh5c2lrLnR1LW11ZW5jaGVuLmRlMEQGCSqGSIb3DQEJDwQ3MDUw
DgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzANBgkq
hkiG9w0BAQUFAAOCAQEAsrZltdEJvGNe4SpJEjeXFLSM14WByMtIlw5kJkPZWiPs0CppsUzNotgg
Mf8O09OgH+3awFL/fMfQiO4RugrRtW0qqi7+8Poo1hWrQ1m4lQgXLRkSh2VQkqQMV+hiM8I+py6h
RbJuFZgx7GBScRUSzAtLFZAMbcw9J5x08syed4j3qEPpeuRbOpdUHVchMCg6dcQjBT5PpddN1C+i
V0JnXI9x0+vIPgz2+V4NgLJ1763pEZzcdDOkqz4uTAJsLQdJxjuqcg35u2jpzDElrzxHH2tzg7H7
a6V+I+vkYR+IvLYHJkBKPj9IwDabBpjUGUP33nDNmPE42cBa5LP2yvR9YDGCAuEwggLdAgEBMGcw
WTESMBAGCgmSJomT8ixkARkWAmNoMRQwEgYKCZImiZPyLGQBGRYEY2VybjEtMCsGA1UEAxMkQ0VS
TiBUcnVzdGVkIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AgpyGYEeAAIAAAJmMAkGBSsOAwIaBQCg
ggFPMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDIwMjE1MDQx
M1owIwYJKoZIhvcNAQkEMRYEFNiGsWHRMjSxmh2eqRMvrGQc60SIMHYGCSsGAQQBgjcQBDFpMGcw
WTESMBAGCgmSJomT8ixkARkWAmNoMRQwEgYKCZImiZPyLGQBGRYEY2VybjEtMCsGA1UEAxMkQ0VS
TiBUcnVzdGVkIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AgpyGYEeAAIAAAJmMHgGCyqGSIb3DQEJ
EAILMWmgZzBZMRIwEAYKCZImiZPyLGQBGRYCY2gxFDASBgoJkiaJk/IsZAEZFgRjZXJuMS0wKwYD
VQQDEyRDRVJOIFRydXN0ZWQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkCCnIZgR4AAgAAAmYwDQYJ
KoZIhvcNAQEBBQAEggEAiHzfW0ISSwKpo/tOysrugq/CEPIxlxrm+/HHTrAxE5SfHSFknNTy4A+Q
hBRnlysjXTwkvfMUsTVKgi38ImErB72MGljstgZ80LP/fpBuSSMl3k6SN3zfc3munE5F2/hE91Qd
M5s8u0zNZn/TfxjK5iqumEJ4ESO13MRuR+CRvw6jTakSCnvzvGHfuGbdMhiXKlyBW3oVTRSxRGmf
WXDiMmRUCXP4k3139n6vX+7d8SDWMwmky91F7V43kXdKGQO43JJbTrkO2agRq8m4kUh0uL2VEZ9R
XujGUCkvDHp9631O4qAS8Blb4uh8t9KssjYUw/XmR8eHxXok6AmDH3o35gAAAAAAAA==

--Apple-Mail-137-995408828--

--Apple-Mail-138-995408851
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (Darwin)

iD8DBQFFw1L4I4MWO8QIRP0RAtQHAKC/vtlziAjk7mi+4VmV5k3FBm/tOQCdFiXx
e7d0BE8xztwg4tfAXRNkzkQ=
=LLm5
-----END PGP SIGNATURE-----

--Apple-Mail-138-995408851--
