Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZADVwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZADVwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZADVvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:51:53 -0500
Received: from yoda.expert-erp.net ([88.198.9.201]:53293 "EHLO
	mail.expert-erp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZADVvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:51:52 -0500
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Message-ID: <49612F69.8080804@opensde.org>
Date: Sun, 04 Jan 2009 22:51:37 +0100
From: Alejandro Mery <amery@opensde.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Rob Landley <rob@landley.net>, Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200901020207.30359.rob@landley.net> <200901020213.30658.rob@landley.net> <200901031328.23079.ioe-lkml@rameria.de>            <200901031936.04642.rob@landley.net> <25035.1231045675@turing-police.cc.vt.edu>
In-Reply-To: <25035.1231045675@turing-police.cc.vt.edu>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms010109040408090708070106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010109040408090708070106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Valdis.Kletnieks@vt.edu wrote:
> Close, but no cee-gar. cut does something counter-intuitive with multiple
> blanks:
>
> % echo 'a    b' | awk '{print $2}'
> b
> % echo 'a    b' | cut -d' ' -f2
>
> % echo 'a    b' | sed -r 's/[ ]+/ /g' | cut -d' ' -f2
> b
>
> Unfortunately, 'sed -r' isn't in the opengroup.org list of required options,
> and sed 's/  / /g' doesn't DTRT for 3 or more blanks (as it won't recursively
> apply the change to a *new* double blank formed by the previous change).
echo 'a    b' | tr -s ' ' | cut -d' ' -f2
b

that is the light way ;-)

Alejandro Mery

--------------ms010109040408090708070106
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
NDIxNTEzN1owIwYJKoZIhvcNAQkEMRYEFI3ucSWMELVvC3C7Fe9cwl2ctoRlMF8GCSqGSIb3
DQEJDzFSMFAwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggq
hkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDBpBgkrBgEEAYI3EAQxXDBaMFQx
FDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcx
HDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAlcFMGsGCyqGSIb3DQEJEAILMVygWjBU
MRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3Jn
MRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgJXBTANBgkqhkiG9w0BAQEFAASCAQB1
ebf2mK2gSsHplWagWYNkEWZ6hjeH9lxEHWXC67xgJzrYGzq9j1URueQqc9ui7XhXmJ9ZtTp7
UlyWQgP1099Gj5edTYy4ig1HUX0CgOfPI2DGYjvnSWx0P/9VKddQFfoUP1LiKJZQ5yo7LOO6
0sDuT1SQSPIWFGzfb9sJgXj49vGpdcxj5brUV04mB7PGRPoPIxzkrUjrCMwyH+l2WO1BPIlq
a4ONkUXxkfTJh6ThZtJR21jO3RVSxIjx0qAo6GWIiirvlBGsHV57zGI6co/WsaaNBN7l0lEO
B+/sHtbNAAoRLkeYsBBu+yrbulFDezvm59BY0cBcoH2tRnNQOoeaAAAAAAAA
--------------ms010109040408090708070106--
