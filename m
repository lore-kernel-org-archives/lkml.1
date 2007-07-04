Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbXGDNK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbXGDNK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbXGDNKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:10:20 -0400
Received: from jonsy.dit.upm.es ([138.4.5.106]:39866 "EHLO jonsy.dit.upm.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbXGDNKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:10:18 -0400
X-Greylist: delayed 4183 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 09:10:18 EDT
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
From: Jonsito <jonsito@teleline.es>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <468AC017.2000300@redhat.com>
References: <1183443365.3006.10.camel@drake.micasa.es>
	 <468AC017.2000300@redhat.com>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-9R6WLuZGaeGIW5fw9YrI"
Organization: Teleline
Date: Wed, 04 Jul 2007 13:58:10 +0200
Message-Id: <1183550290.30882.8.camel@jonsy.dit.upm.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9R6WLuZGaeGIW5fw9YrI
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

El mar, 03-07-2007 a las 17:31 -0400, Chuck Ebbert escribi=F3:
> On 07/03/2007 02:16 AM, Juan Antonio Martinez wrote:
[...]
> When it is working it says:
>=20
> ppdev: user-space parallel port driver
> ppdev0: registered pardevice
> ppdev0: unregistered pardevice
> ppdev0: registered pardevice
> ppdev0: negotiated back to compatibility mode because user-space forgot
> ppdev0: unregistered pardevice
> ppdev0: registered pardevice
> ppdev0: unregistered pardevice
>=20
> When broken:
>=20
> ppdev: user-space parallel port driver
> ppdev0: registered pardevice
> ppdev0: unregistered pardevice
>=20
> I give up, what causes that?

Please skip extra registered/unregistered pairs: was additional tests.

More info:

I've download vanilla libieee1284 and linux-2.6.21.5 code
libieee1284 includes kernel headers for ppdev.h and parport.h;=20
they are slightly different than kernel ones, but differences=20
only apply to "#ifdef __KERNEL" section.=20
Not sure on collateral effects

libieee1284 fails in claim() returning E1284_SYS (System Call Error).
Failed line is "ioctl(port->fd, PPCLAIM)" from access_ppdev.c

Looking at ppdev.c seems that parport_claim_or_block() fails.=20
Need further study

Juan Antonio


--=-9R6WLuZGaeGIW5fw9YrI
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKkDCCBUQw
ggStoAMCAQICBDx9KH8wDQYJKoZIhvcNAQEFBQAwNjELMAkGA1UEBhMCRVMxDTALBgNVBAoTBEZO
TVQxGDAWBgNVBAsTD0ZOTVQgQ2xhc2UgMiBDQTAeFw0wNDEwMTkxMzM2MjdaFw0wNzEwMTkxMzM2
MjdaMIGJMQswCQYDVQQGEwJFUzENMAsGA1UEChMERk5NVDEYMBYGA1UECxMPRk5NVCBDbGFzZSAy
IENBMRIwEAYDVQQLEwk1MDAwNTE0ODMxPTA7BgNVBAMUNE5PTUJSRSBNQVJUSU5FWiBDQVNUQfFP
IEpVQU4gQU5UT05JTyAtIE5JRiA1MDQzMTEzOEcwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGB
ANFa4JHJtYmpy9g5l8FVepaJpTiNE3Lovlq3xC7gPzgHIiF0ltY9O+r1TcbmdRRrxNo2az+bRlw8
/SyYXQ0Vk+WYEoLfbMFMDdUu40sFeynEogv4jjWDFD21llsW+8Xm3AzRQGkOEZuRrV/GQFWjockf
uUtazWSTnevdTcuGEK5LAgMBAAGjggMJMIIDBTCBiAYDVR0RBIGAMH6BEEpPTlNJVE9AVEVSUkEu
RVOkajBoMRgwFgYJKwYBBAGsZgEEEwk1MDQzMTEzOEcxFjAUBgkrBgEEAaxmAQMUB0NBU1RB8U8x
FzAVBgkrBgEEAaxmAQITCE1BUlRJTkVaMRswGQYJKwYBBAGsZgEBEwxKVUFOIEFOVE9OSU8wCQYD
VR0TBAIwADArBgNVHRAEJDAigA8yMDA0MTAxOTEzMzYyN1qBDzIwMDcxMDE5MTMzNjI3WjALBgNV
HQ8EBAMCBaAwEQYJYIZIAYb4QgEBBAQDAgWgMB0GA1UdDgQWBBQQ5VIj7JvbBBsq6Wxx3t6vHPji
vjAfBgNVHSMEGDAWgBRAmnZEl3QHxKwUyx6NTzpFfDDXYTCCATEGA1UdIASCASgwggEkMIIBIAYJ
KwYBBAGsZgMFMIIBETA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5jZXJ0LmZubXQuZXMvY29udmVu
aW8vZHBjLnBkZjCB2AYIKwYBBQUHAgIwgcsagchDZXJ0aWZpY2FkbyBSZWNvbm9jaWRvIGV4cGVk
aWRvIHNlZ/puIGxlZ2lzbGFjafNuIHZpZ2VudGUuVXNvIGxpbWl0YWRvIGEgbGEgQ29tdW5pZGFk
IEVsZWN0cvNuaWNhIHBvciB2YWxvciBt4XhpbW8gZGUgMTAwIGUgc2Fsdm8gZXhjZXBjaW9uZXMg
ZW4gRFBDLkNvbnRhY3RvIEZOTVQ6Qy9Kb3JnZSBKdWFuIDEwNi0yODAwOS1NYWRyaWQtRXNwYfFh
LjAdBgkrBgEEAaxmASEEEBYOUEVSU09OQSBGSVNJQ0EwLwYIKwYBBQUHAQMEIzAhMAgGBgQAjkYB
ATAVBgYEAI5GAQIwCxMDRVVSAgFkAgEAMFsGA1UdHwRUMFIwUKBOoEykSjBIMQswCQYDVQQGEwJF
UzENMAsGA1UEChMERk5NVDEYMBYGA1UECxMPRk5NVCBDbGFzZSAyIENBMRAwDgYDVQQDEwdDUkwx
NTU2MA0GCSqGSIb3DQEBBQUAA4GBAI6lP0og4o0zVQOr7/QPPg5lC+5BhSFNsXBiyP5j7xNrCkim
7zgCsqIUvZLjYGlL1ChiXniD1VUaylMAdX/p0uMe6ZIkxnA1KOGiMyGMaAk9MiXNnSX5mg3Q5/6H
eTqRFpwVfC4FGNRowKVjrU8iFt6rBAUdA+65F95NnLSAPI6gMIIFRDCCBK2gAwIBAgIEPH0ofzAN
BgkqhkiG9w0BAQUFADA2MQswCQYDVQQGEwJFUzENMAsGA1UEChMERk5NVDEYMBYGA1UECxMPRk5N
VCBDbGFzZSAyIENBMB4XDTA0MTAxOTEzMzYyN1oXDTA3MTAxOTEzMzYyN1owgYkxCzAJBgNVBAYT
AkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ExEjAQBgNVBAsTCTUw
MDA1MTQ4MzE9MDsGA1UEAxQ0Tk9NQlJFIE1BUlRJTkVaIENBU1RB8U8gSlVBTiBBTlRPTklPIC0g
TklGIDUwNDMxMTM4RzCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA0Vrgkcm1ianL2DmXwVV6
lomlOI0Tcui+WrfELuA/OAciIXSW1j076vVNxuZ1FGvE2jZrP5tGXDz9LJhdDRWT5ZgSgt9swUwN
1S7jSwV7KcSiC/iONYMUPbWWWxb7xebcDNFAaQ4Rm5GtX8ZAVaOhyR+5S1rNZJOd691Ny4YQrksC
AwEAAaOCAwkwggMFMIGIBgNVHREEgYAwfoEQSk9OU0lUT0BURVJSQS5FU6RqMGgxGDAWBgkrBgEE
AaxmAQQTCTUwNDMxMTM4RzEWMBQGCSsGAQQBrGYBAxQHQ0FTVEHxTzEXMBUGCSsGAQQBrGYBAhMI
TUFSVElORVoxGzAZBgkrBgEEAaxmAQETDEpVQU4gQU5UT05JTzAJBgNVHRMEAjAAMCsGA1UdEAQk
MCKADzIwMDQxMDE5MTMzNjI3WoEPMjAwNzEwMTkxMzM2MjdaMAsGA1UdDwQEAwIFoDARBglghkgB
hvhCAQEEBAMCBaAwHQYDVR0OBBYEFBDlUiPsm9sEGyrpbHHe3q8c+OK+MB8GA1UdIwQYMBaAFECa
dkSXdAfErBTLHo1POkV8MNdhMIIBMQYDVR0gBIIBKDCCASQwggEgBgkrBgEEAaxmAwUwggERMDQG
CCsGAQUFBwIBFihodHRwOi8vd3d3LmNlcnQuZm5tdC5lcy9jb252ZW5pby9kcGMucGRmMIHYBggr
BgEFBQcCAjCByxqByENlcnRpZmljYWRvIFJlY29ub2NpZG8gZXhwZWRpZG8gc2Vn+m4gbGVnaXNs
YWNp824gdmlnZW50ZS5Vc28gbGltaXRhZG8gYSBsYSBDb211bmlkYWQgRWxlY3Ry825pY2EgcG9y
IHZhbG9yIG3heGltbyBkZSAxMDAgZSBzYWx2byBleGNlcGNpb25lcyBlbiBEUEMuQ29udGFjdG8g
Rk5NVDpDL0pvcmdlIEp1YW4gMTA2LTI4MDA5LU1hZHJpZC1Fc3Bh8WEuMB0GCSsGAQQBrGYBIQQQ
Fg5QRVJTT05BIEZJU0lDQTAvBggrBgEFBQcBAwQjMCEwCAYGBACORgEBMBUGBgQAjkYBAjALEwNF
VVICAWQCAQAwWwYDVR0fBFQwUjBQoE6gTKRKMEgxCzAJBgNVBAYTAkVTMQ0wCwYDVQQKEwRGTk1U
MRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ExEDAOBgNVBAMTB0NSTDE1NTYwDQYJKoZIhvcNAQEF
BQADgYEAjqU/SiDijTNVA6vv9A8+DmUL7kGFIU2xcGLI/mPvE2sKSKbvOAKyohS9kuNgaUvUKGJe
eIPVVRrKUwB1f+nS4x7pkiTGcDUo4aIzIYxoCT0yJc2dJfmaDdDn/od5OpEWnBV8LgUY1GjApWOt
TyIW3qsEBR0D7rkX3k2ctIA8jqAxggHkMIIB4AIBATA+MDYxCzAJBgNVBAYTAkVTMQ0wCwYDVQQK
EwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ECBDx9KH8wCQYFKw4DAhoFAKCB/TAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzA3MDQxMTU4MDNaMCMGCSqG
SIb3DQEJBDEWBBSqfiml/G19/SfEGEYf8NRyNerg4jBNBgkrBgEEAYI3EAQxQDA+MDYxCzAJBgNV
BAYTAkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ECBDx9KH8wTwYL
KoZIhvcNAQkQAgsxQKA+MDYxCzAJBgNVBAYTAkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9G
Tk1UIENsYXNlIDIgQ0ECBDx9KH8wDQYJKoZIhvcNAQEBBQAEgYBt6u5Dntpzjw1GcwAPzEhJ2YSG
7KSQ2RWg2XJgqUnG9TtTEVE4MSDUjCFBH9/a1KIObOiBaAEG/kn2O3fiXuxddvetk7zQTPmRu59W
vvuQv9vW4nIy4548GVhNt4sDJbqmR6LCGMm5xmGFtYfanXMgxkd5rckvI7mE2JxmUcLh2QAAAAAA
AA==


--=-9R6WLuZGaeGIW5fw9YrI--
