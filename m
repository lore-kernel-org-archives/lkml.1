Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbZABKXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbZABKXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZABKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:23:42 -0500
Received: from yoda.expert-erp.net ([88.198.9.201]:33015 "EHLO
	mail.expert-erp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZABKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:23:41 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 05:23:40 EST
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Message-ID: <495DE995.1070002@opensde.org>
Date: Fri, 02 Jan 2009 11:16:53 +0100
From: Alejandro Mery <amery@opensde.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org>
In-Reply-To: <20090102094934.GB17841@infradead.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms000306060703070308010405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000306060703070308010405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig escribi=F3:
> On Fri, Jan 02, 2009 at 10:26:37AM +0100, Arkadiusz Miskiewicz wrote:
>  =20
>> On Friday 02 of January 2009, Rob Landley wrote:
>>    =20
>>> Before 2.6.25 (specifically git bdc807871d58285737d50dc6163d0feb72cb0=
dc2 )
>>> building a Linux kernel never required perl to be installed on the bu=
ild
>>> system.  (Various development and debugging scripts were written in p=
erl
>>> and python and such, but they weren't involved in actually building a=

>>> kernel.) Building a kernel before 2.6.25 could be done with a minimal=

>>> system built from gcc, binutils, bash, make, busybox, uClibc, and the=
 Linux
>>> kernel, and nothing else.
>>>      =20
>> And now bash is going to be required... while some distros don't need/=
have=20
>> bash. /bin/sh should be enough.
>>    =20
>
> *nod*  bash is in many ways a worse requirement than perl.  strict posi=
x
> /bin/sh + awk + sed would be nicest, but if that's too much work perl
> seems reasonable.
well, bash is not worse as bash is trivial to cross-compile to run on a
constrained sandbox and perl is a nightmare, but I agree bash should be
avoided too.

I think the $(( ... )) bash-ism can be replaced with a simple .c helper t=
oy.

Thank Rob for reopening the topic.

Alejandro Mery


--------------ms000306060703070308010405
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQPDCC
BRQwggL8oAMCAQICAlcFMA0GCSqGSIb3DQEBBQUAMFQxFDASBgNVBAoTC0NBY2VydCBJbmMu
MR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBDbGFz
cyAzIFJvb3QwHhcNMDgwNjEyMTU1MzU4WhcNMTAwNjEyMTU1MzU4WjBGMSIwIAYDVQQDExlB
bGVqYW5kcm8gTWVyeSBQZWxsZWdyaW5pMSAwHgYJKoZIhvcNAQkBFhFhbWVyeUBvcGVuc2Rl
Lm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN/9qsONmtqxRdR/Lj7BbEcz
tlsNIJyOR1a9lgGy+dMDmMP5vwmnGLpDGIUw3gUd2a8oeJwWGx7pH/ALe49z0CB2/R9Ivfl0
+e/51BgaXBzbfP0yKC9BB7++OZPF2KHbNn4Y3h6rScj1hodvavwkCZmg8PARE2yPe5vobUJ6
8P/VA14IxJrSsAp7gE9MQzrmmiFa/aSDtb80XqJCn7tC84jtjvS6rf9of3XmIatAUt0qZ67m
EdViW13uS2nEBWn7Aub6FRJs7EicNYyhOUy2MmrrQ749xCf01wQsNhHC9tVByDdhjTDRe+WX
n0B4OePJ6u7gq/CKGqQGBt/MegEhq80CAwEAAaOB/TCB+jAMBgNVHRMBAf8EAjAAMFYGCWCG
SAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUgZm9yIEZSRUUgaGVhZCBv
dmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYB
BQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQm
MCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2VydC5vcmcwHAYDVR0RBBUwE4ERYW1l
cnlAb3BlbnNkZS5vcmcwDQYJKoZIhvcNAQEFBQADggIBAJIneO6q7FI+JtqFQn9ut97rgjOH
OCrElGthSBabgVmh7JHM4cmiK0EkLvuOPlho2DnbDvqPdjtt4j7FJSrvqwdj+WM2zlSm4NWZ
audK/WzQJw7/7+uJCBlr1ubmWRuyvDl7DbMpVOMOwIdhIZ6tVx+UQ2iceAWZvW3TRWxKz2yi
zzayDbyYLKYZE+UJuiKk8+8TSfu4k9PrfOZq1gaqkxx2uLW9+Sc1/CnxjkL3z6F+oAu1ygHq
2trFF4AJar2kFSKZxfRjx5PCoBNaNYqTx0Q4x/83pM2YwLuDAUyuHTINUHtuH2gSOjKrD4Et
4VVv2d06r43ypdayHaWnAcX2Gi4BNVxoOYM5c2JocBgmueIPbLiCemrrVjH+K0cLA0pB143d
ZwJ/Xo0KGX2t9DoeuBO09zSOgG3QBhJFVqkH+T0bt54/IWVU6/eoOeFIjMtZoIs92gAl7VLB
jt/C8gUmhnEacupMyv/91zu4nBpjsTJizHd1jPBdANW5CVryaVz+BIbK9z1OBwXA5fecQWIJ
4aZEJUDjt6NJiHIwCAWnT0g4qZDb84ap8ms+yvJVFS+a8hYtw2PqO09bHQaLtltS2k2+gZeK
RIvZ+5sjL3KKUjaeiPRIRqBLqYgZqC5dyrSGIxqbokHaAfpbyW27k/eKJ/jZzBMMxudzPwEJ
Zl9vInpIMIIFFDCCAvygAwIBAgICVwUwDQYJKoZIhvcNAQEFBQAwVDEUMBIGA1UEChMLQ0Fj
ZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0Fj
ZXJ0IENsYXNzIDMgUm9vdDAeFw0wODA2MTIxNTUzNThaFw0xMDA2MTIxNTUzNThaMEYxIjAg
BgNVBAMTGUFsZWphbmRybyBNZXJ5IFBlbGxlZ3JpbmkxIDAeBgkqhkiG9w0BCQEWEWFtZXJ5
QG9wZW5zZGUub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3/2qw42a2rFF
1H8uPsFsRzO2Ww0gnI5HVr2WAbL50wOYw/m/CacYukMYhTDeBR3Zryh4nBYbHukf8At7j3PQ
IHb9H0i9+XT57/nUGBpcHNt8/TIoL0EHv745k8XYods2fhjeHqtJyPWGh29q/CQJmaDw8BET
bI97m+htQnrw/9UDXgjEmtKwCnuAT0xDOuaaIVr9pIO1vzReokKfu0LziO2O9Lqt/2h/deYh
q0BS3SpnruYR1WJbXe5LacQFafsC5voVEmzsSJw1jKE5TLYyautDvj3EJ/TXBCw2EcL21UHI
N2GNMNF75ZefQHg548nq7uCr8IoapAYG38x6ASGrzQIDAQABo4H9MIH6MAwGA1UdEwEB/wQC
MAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJF
RSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMEAGA1UdJQQ5MDcGCCsGAQUF
BwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsG
AQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9yZzAcBgNVHREE
FTATgRFhbWVyeUBvcGVuc2RlLm9yZzANBgkqhkiG9w0BAQUFAAOCAgEAkid47qrsUj4m2oVC
f2633uuCM4c4KsSUa2FIFpuBWaHskczhyaIrQSQu+44+WGjYOdsO+o92O23iPsUlKu+rB2P5
YzbOVKbg1Zlq50r9bNAnDv/v64kIGWvW5uZZG7K8OXsNsylU4w7Ah2Ehnq1XH5RDaJx4BZm9
bdNFbErPbKLPNrINvJgsphkT5Qm6IqTz7xNJ+7iT0+t85mrWBqqTHHa4tb35JzX8KfGOQvfP
oX6gC7XKAera2sUXgAlqvaQVIpnF9GPHk8KgE1o1ipPHRDjH/zekzZjAu4MBTK4dMg1Qe24f
aBI6MqsPgS3hVW/Z3TqvjfKl1rIdpacBxfYaLgE1XGg5gzlzYmhwGCa54g9suIJ6autWMf4r
RwsDSkHXjd1nAn9ejQoZfa30Oh64E7T3NI6AbdAGEkVWqQf5PRu3nj8hZVTr96g54UiMy1mg
iz3aACXtUsGO38LyBSaGcRpy6kzK//3XO7icGmOxMmLMd3WM8F0A1bkJWvJpXP4Ehsr3PU4H
BcDl95xBYgnhpkQlQOO3o0mIcjAIBadPSDipkNvzhqnyaz7K8lUVL5ryFi3DY+o7T1sdBou2
W1LaTb6Bl4pEi9n7myMvcopSNp6I9EhGoEupiBmoLl3KtIYjGpuiQdoB+lvJbbuT94on+NnM
EwzG53M/AQlmX28iekgwggYIMIID8KADAgECAgEBMA0GCSqGSIb3DQEBBAUAMHkxEDAOBgNV
BAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZ
Q0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNl
cnQub3JnMB4XDTA1MTAxNDA3MzY1NVoXDTMzMDMyODA3MzY1NVowVDEUMBIGA1UEChMLQ0Fj
ZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0Fj
ZXJ0IENsYXNzIDMgUm9vdDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKtJNRFI
fNImflOUz0Op3SjXQiqL84d4GVh8D57aiX3h++tykA10oZZkq5+gJJlz2uJVdscXe/UErEa4
w75/ZI0QbCTzYZzA8pD6Ueb1aQFjww9W4kpCz+JEjCUoqMV5CX1GuYrz6fM0KQhF5Byfy5QE
HIGoFLOYZcRD7E6CjQnRvapbjZLQ7N6QxX8KwuPr5jFaXnQ+lzNZ6MMDPWAzv/fRb0fEze5i
g1JuLgiapNkVGJGmhZJHsK5I6223IeyFGmhyNav/8BBdwPSUp2rVO5J+TJAFfpPBLIukjmJ0
FXFuC3ED6q8VOJrU0gVyb4z5K+taciX5OUbjchs+BMNkJyIQKopPWKcDrb60LhPtXapI19V9
1Cp7XPpGBFDkzA5CW4zt2/LP/JaT4NsRNlRiNDiPDGCbO5dWOK3z0luLoFvqTpa4fNfVoIZw
QNORKbeiPK31jLvPGpKK5DR7wNhsX+kKwsOnIJpa3yxdUly6R9Wb7yQocDggL9V/KcCyQQNo
kszgnMyXS0XvOhAKq3A6mJVwrTWx6oUrpByAITGprmB6gCZIALgBwJNjVSKRPFbnr9s6JfOP
MVTqJouBWfmh0VMRxXudA/Z0EeBtsSw/LIaRmXGapneLNGDRFLQsrJ2vjBDTn8Rq+G8T/HNZ
92ZCdB6K4/jc0m+YnMtHmJVABfvpAgMBAAGjgb8wgbwwDwYDVR0TAQH/BAUwAwEB/zBdBggr
BgEFBQcBAQRRME8wIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLkNBY2VydC5vcmcvMCgGCCsG
AQUFBzAChhxodHRwOi8vd3d3LkNBY2VydC5vcmcvY2EuY3J0MEoGA1UdIARDMEEwPwYIKwYB
BAGBkEowMzAxBggrBgEFBQcCARYlaHR0cDovL3d3dy5DQWNlcnQub3JnL2luZGV4LnBocD9p
ZD0xMDANBgkqhkiG9w0BAQQFAAOCAgEAfwiIodoaUEnaifuhCHLzivcexDq0eVsgMLFF3sJd
02Vp8cJdVFQ8hV+5e0KRwpn9G1Gbq0aloRBTnm2IrHNuLDOm8PSe4HXBPohFqeFmQ/5WWtF6
QXj3QNpKOvELW6W7FgbmwueTuYVNl0+xHjhDgO+bDYzvuKdgAIdXfR5EHMsj75s8mZ2vtSkc
RXkWlk0nbfEcbMPCVWSzvBTi86QfHjL8JxUFz90urj6CYXvwIRAY9kTqUzn53NCaIODGu+C7
Wk/EmcgHvbW9otsuYg1CNEG8/4uK9VEiqogwAOKw1Ly+ZbrVA1d5m+jcyE34UO2RpVIooqz7
Nlg+6ZQrkVCHG9Ze1ozM9w8QDFJO0BZh5eUKbL8Xx3JGV5yY9WxgY3pvXrlOL8i5ubtqhbyY
De35PpeENJSuAK+h5eeSbk698+LZFItc0usBbKAXpS0Q65x6Sr297s797SJAq3A4iPUKh2rC
qwVgyUgF2lPB3kR3arPzPDztgLymOEopJF/+WTubJXpWYwBkuV2kYn1XNk+tg+8fklOgjndX
3eVhET0jAJBMPPqjYJMEo6819g5qj09KYKeFBWxGoY/0x3bjoVlX93GyxG4UXG1tQWbfG5Ox
1ADD7svPPD0hgKlfY2X83eBfpPQr8IVxQdRnJfsasZeu1pmCE0HSbqUbmSeA5wupqAAxggMb
MIIDFwIBATBaMFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3
LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAlcFMAkGBSsOAwIa
BQCgggGWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA5MDEw
MjEwMTY1M1owIwYJKoZIhvcNAQkEMRYEFBkZZ1eI3n/KrFN6JxRQSCDQ1Tl+MF8GCSqGSIb3
DQEJDzFSMFAwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggq
hkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDBpBgkrBgEEAYI3EAQxXDBaMFQx
FDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcx
HDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAlcFMGsGCyqGSIb3DQEJEAILMVygWjBU
MRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3Jn
MRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgJXBTANBgkqhkiG9w0BAQEFAASCAQCr
ab2ysRtVX+TrYJbpY4HEwsElZgM11HLSSY1h3eadaYhWuQVWNr1+2k/3amk16r+es/T2xVSU
gbTFTb12ZOTfj4meo3Zd6a9NkPOFYz9UL6H1zjzwFbM0C+hCgF9tIwITaW0iRBYN8wy4xppN
ECVHAIe2NLVKBXBia5JTHD3oEVt/52Ji5rtyju03SZhGl7gVweEHOWmzEq1D97WX1wvg4seT
4rPhDhHHD8nw93TpYd3lfNkOvhUmitdMEnwmF5a+twEAWaVpq7a1FIrdQh4xJmOdZobUiAV6
U3IO4LvBUoruqQHRrNsSBRB86qkpyl1Z/hMdouRWpq3SLfJC/nL1AAAAAAAA
--------------ms000306060703070308010405--
