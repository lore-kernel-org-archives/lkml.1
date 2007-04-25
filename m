Return-Path: <linux-kernel-owner+w=401wt.eu-S2992785AbXDYN7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992785AbXDYN7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992789AbXDYN7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:59:16 -0400
Received: from rk.rkuhn.info ([88.198.164.84]:48773 "EHLO mailhost.rkuhn.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992785AbXDYN7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:59:14 -0400
In-Reply-To: <20070425101857.GR9715@kernel.dk>
References: <46261ACE.1050407@wasp.net.au> <20070418132157.GC3720@kernel.dk> <462B10C3.1030906@wasp.net.au> <20070423073543.GE5311@kernel.dk> <462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown> <20070425084607.GM9715@kernel.dk> <17967.8536.788076.851546@notabene.brown> <20070425094712.GP9715@kernel.dk> <462F2727.7090205@wasp.net.au> <20070425101857.GR9715@kernel.dk>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-25--513638275"
Message-Id: <4550D18B-13EF-4A14-8BE2-CA6F374E8094@e18.physik.tu-muenchen.de>
Cc: Brad Campbell <brad@wasp.net.au>, Neil Brown <neilb@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, lkml <linux-kernel@vger.kernel.org>
From: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Date: Wed, 25 Apr 2007 15:59:00 +0200
To: Jens Axboe <jens.axboe@oracle.com>
Content-Transfer-Encoding: 7bit
X-Pgp-Agent: GPGMail 1.1.2 (Tiger)
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-25--513638275
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-24--513638309; protocol="application/pkcs7-signature"


--Apple-Mail-24--513638309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hi Jens!

On 25 Apr 2007, at 12:18, Jens Axboe wrote:

> On Wed, Apr 25 2007, Brad Campbell wrote:
>> Jens Axboe wrote:
>>
>>> It looks to be extremely rare. Aliases are extremely rare, front  
>>> merges
>>> are rare. And you need both to happen with the details you  
>>> outlined. But
>>> it's a large user base, and we've had 3-4 reports on this in the  
>>> past
>>> months. So it obviously does happen. I could not make it trigger  
>>> without
>>> doctoring the unplug code when I used aio.
>>
>> Well, not that rare on this particular machine (I had a case where  
>> I could
>> reproduce it in less than an hour of normal use previously on this  
>> box),
>> and I've had it occur a number of times on my servers, I just never
>> reported it before as I never took the time to set up a serial  
>> console and
>> capture the oops.
>
> Extremely rare in the sense that it takes md and some certain  
> conditions
> to happen for it to trigger. So for most people it'll be extremely  
> rare,
> and for others (such as yourself) that hit it, it wont be so rare :-)
>
>>> Here's a fix for it, confirmed.
>>
>> Shall I leave the other debugging in, apply this and run it for a  
>> few hard
>> days?
>
> Yes, that would be perfect!
>
Okay, I left all debugging patches in, disabled all kernel  
debugging .config stuff and gave it a spin with our usual "killer"  
workload (as far as batch systems are repeatable anyway) and so far  
there was not a single glitch or message, so I preliminarily conclude  
that the bug is squashed. The final word will come once my 1800 batch  
jobs are processed and I have my particle physics result ;-)

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



--Apple-Mail-24--513638309
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
ggFPMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDQyNTEzNTkw
MVowIwYJKoZIhvcNAQkEMRYEFPYvw5jHJpNxf9TbkRDaOM3mvfEoMHYGCSsGAQQBgjcQBDFpMGcw
WTESMBAGCgmSJomT8ixkARkWAmNoMRQwEgYKCZImiZPyLGQBGRYEY2VybjEtMCsGA1UEAxMkQ0VS
TiBUcnVzdGVkIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AgpyGYEeAAIAAAJmMHgGCyqGSIb3DQEJ
EAILMWmgZzBZMRIwEAYKCZImiZPyLGQBGRYCY2gxFDASBgoJkiaJk/IsZAEZFgRjZXJuMS0wKwYD
VQQDEyRDRVJOIFRydXN0ZWQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkCCnIZgR4AAgAAAmYwDQYJ
KoZIhvcNAQEBBQAEggEAnb7gErdoK9UR/PkDC69lzMLfb0XCkVFPtyS5CkdKZzhc8ZC04euw8VqB
bP09ojzXQlfQk3KMSlpqIkMrVlEuC4i5U5PqsTZG9KgQZcpkUypq8QvPDUyfuGqcJyCWLMhhoTrl
iKDRAro7+Uf8p+fcwjBTUPpPajzaTH+3t0TtND4Bj28JHO7nu9KC49KOdFn6pv0rK594RRRsSSUc
JJArNUNqSqBdPT5oqBWPgewUt0uQxxqG5NPM2Gxtwk2I9HWVu3AK4BlZ/VMNBESejz/WEu5VV55f
k6GxSdJDI5xPOMIBZkTuAlEn6FC29DoQhbo2LAqaRo9ur8m0MNnYjWrdTgAAAAAAAA==

--Apple-Mail-24--513638309--

--Apple-Mail-25--513638275
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (Darwin)

iD8DBQFGL16tI4MWO8QIRP0RAnNLAJ4vjf9eDMEAmDd6i81BnhMthUQTfACgt14P
e0hDGXSOnw40oreJaCo3Zvk=
=ldGo
-----END PGP SIGNATURE-----

--Apple-Mail-25--513638275--
