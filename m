Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbXLSIYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbXLSIYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 03:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXLSIX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 03:23:56 -0500
Received: from firewall1.addi-data.de ([62.154.208.154]:47894 "EHLO
	firewal1.addi-data.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100AbXLSIXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 03:23:55 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed; 
    boundary="----_=_NextPart_001_01C84218.79C9831C"
Subject: AW: AW: [PATCH] serial: add ADDI-DATA GmbH Communication
 cardsin8250_pci.c and pci_ids.h.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 19 Dec 2007 09:23:46 +0100
Message-ID: <DD0BA80209AFF04091B518EA708D0A0BA24A3E@exchange01.addi-data.intra>
In-Reply-To: <20071218152554.c2ded155.akpm@linux-foundation.org>
Thread-Topic: AW: [PATCH] serial: add ADDI-DATA GmbH Communication  
    cardsin8250_pci.c and pci_ids.h.
Thread-Index: AchBzY1YiHSp/5MSSQKFX7aB6gkeCQASpwLg
References: <DD0BA80209AFF04091B518EA708D0A0B9F91BF@exchange01.addi-data.intra><20071128104914.GA23074@pazke.donpac.ru><DD0BA80209AFF04091B518EA708D0A0B9F9210@exchange01.addi-data.intra><20071130071339.GB24928@pazke.donpac.ru><DD0BA80209AFF04091B518EA708D0A0BA23ED5@exchange01.addi-data.intra> 
     <20071218152554.c2ded155.akpm@linux-foundation.org>
From: "Krauth.Julien" <Krauth.Julien@addi-data.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C84218.79C9831C
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

As suggested by Andrew Morton, the patch is now as attachment.

Best regards,
Krauth Julien

-----Urspr=FCngliche Nachricht-----
Von: Andrew Morton [mailto:akpm@linux-foundation.org]=20
Gesendet: Mittwoch, 19. Dezember 2007 00:26
An: Krauth.Julien
Betreff: Re: AW: [PATCH] serial: add ADDI-DATA GmbH Communication cardsin82=
50_pci.c and pci_ids.h.

On Thu, 6 Dec 2007 08:49:44 +0100
"Krauth.Julien" <Krauth.Julien@addi-data.com> wrote:

>=20
> Hello,
>=20
> Here is the last version of the patch updated regarding your remarks.
>=20
> Regards,
>=20
> Julien Krauth
>=20
> Changes:
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> - Indentation.
>=20
> - Code optimisation: all boards except the APCI-7800 are now managed
> with the pci_default_setup() function.
>=20
> - Add pbn_b0_8_115200 to manage the APCI-7800-3 with the
> pci_default_setup() function.
>=20
>=20
> ---
>=20
> From: Krauth Julien <krauth.julien@addi-data.com>
>=20
> Add ADDI-DATA GmbH communication cards to 8250_pci driver.
> Supported cards are:
>=20
> APCI-7300, APCI-7420, APCI-7500, APCI-7800 APCI-7300-2, APCI-7420-2,
> APCI-7500-2 APCI-7300-3, APCI-7420-3, APCI-7500-3, APCI-7800-3
>=20
> 8250_pci.c.patch
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Add ADDI-DATA GmbH communication cards to 8250_pci.c.
>=20
> pci_ids.h.patch
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Add ADDI-DATA GmbH communication cards Vendor and Device IDs to
> pci_ids.h.
>=20
> WARNING:
> =3D=3D=3D=3D=3D=3D=3D=3D
> 8250_pci.c.patch depend on pci_ids.h.patch.
> 8250_pci.c is using Vendor and Device ID defined in pci_ids.h.
>=20
>=20

This patch was hopelessly mangled by your email client: wordwrapped and
strange whitespace substitutions.

I suggest that when you resend it, you use attachments.

ADDI-DATA GmbH - Dieselstra=DFe 3 - 77833 Ottersweier (Germany)
Amtsgericht Mannheim HRB210433
Gesch=E4ftsf=FChrer Antonio Agnetti, Ren=E9 Ohlmann=20
UST-ID-Nr.: DE 143754253 WEEE-Reg.-Nr. DE 65862200

This email and any files transmitted with it are confidential and intended=
=20
solely for the use of the individual or entity to whom they are addressed. =
If you have received this email in error please notify the system manager.
This footnote confirms that this email message has been scanned for the pre=
sence of computer viruses.


------_=_NextPart_001_01C84218.79C9831C
Content-Type: application/octet-stream; name="8250_pci.c.patch"
Content-Transfer-Encoding: base64
Content-Description: 8250_pci.c.patch
Content-Disposition: attachment; filename="8250_pci.c.patch"

LS0tIGxpbnV4LTIuNi4yMy45LXZhbmlsbGEvZHJpdmVycy9zZXJpYWwvODI1MF9wY2kuYwkyMDA3
LTExLTI2IDE4OjUxOjQzLjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi42LjIzLjkvZHJpdmVy
cy9zZXJpYWwvODI1MF9wY2kuYwkyMDA3LTExLTMwIDA4OjMzOjUwLjAwMDAwMDAwMCArMDEwMApA
QCAtMTA2LDYgKzEwNiwzMiBAQCBzZXR1cF9wb3J0KHN0cnVjdCBzZXJpYWxfcHJpdmF0ZSAqcHJp
diwgCiB9CiAKIC8qCisgKiBBRERJLURBVEEgR21iSCBjb21tdW5pY2F0aW9uIGNhcmRzIDxpbmZv
QGFkZGktZGF0YS5jb20+CisgKi8KK3N0YXRpYyBpbnQKK2FkZGlkYXRhX2FwY2k3ODAwX3NldHVw
KHN0cnVjdCBzZXJpYWxfcHJpdmF0ZSAqcHJpdiwgc3RydWN0IHBjaXNlcmlhbF9ib2FyZCAqYm9h
cmQsCisgICAgICAgICAgICAgICBzdHJ1Y3QgdWFydF9wb3J0ICpwb3J0LCBpbnQgaWR4KQorewor
CXVuc2lnbmVkIGludCBiYXIgPSAwLCBvZmZzZXQgPSBib2FyZC0+Zmlyc3Rfb2Zmc2V0OworCWJh
ciA9IEZMX0dFVF9CQVNFKGJvYXJkLT5mbGFncyk7CisKKwlpZiAoaWR4IDwgMiApIHsKKwkJb2Zm
c2V0ICs9IGlkeCAqIGJvYXJkLT51YXJ0X29mZnNldDsKKwl9IGVsc2UgaWYgKChpZHggPj0gMikg
JiYgKGlkeCA8IDQpKSB7CisJCWJhciArPSAxOworCQlvZmZzZXQgKz0gKChpZHggLSAyKSAqIGJv
YXJkLT51YXJ0X29mZnNldCk7CisJfSBlbHNlIGlmICgoaWR4ID49IDQpICYmIChpZHggPCA2ICkp
IHsKKwkJYmFyICs9IDI7CisJCW9mZnNldCArPSAoKGlkeCAtIDQpICogYm9hcmQtPnVhcnRfb2Zm
c2V0KTsKKwl9IGVsc2UgaWYgKGlkeCA+PSA2KSB7CisJCWJhciArPSAzOworCQlvZmZzZXQgKz0g
KChpZHggLSA2KSAqIGJvYXJkLT51YXJ0X29mZnNldCk7CisJfQorCisJcmV0dXJuIHNldHVwX3Bv
cnQocHJpdiwgcG9ydCwgYmFyLCBvZmZzZXQsIGJvYXJkLT5yZWdfc2hpZnQpOworfQorCisvKgog
ICogQUZBVkxBQiB1c2VzIGEgZGlmZmVyZW50IG1peHR1cmUgb2YgQkFScyBhbmQgb2Zmc2V0cwog
ICogTm90IHRoYXQgdWdseSA7KSAtLSBIVwogICovCkBAIC03NTIsNiArNzc4LDE2IEBAIHBjaV9k
ZWZhdWx0X3NldHVwKHN0cnVjdCBzZXJpYWxfcHJpdmF0ZSAKICAqLwogc3RhdGljIHN0cnVjdCBw
Y2lfc2VyaWFsX3F1aXJrIHBjaV9zZXJpYWxfcXVpcmtzW10gPSB7CiAJLyoKKwkqIEFEREktREFU
QSBHbWJIIGNvbW11bmljYXRpb24gY2FyZHMgPGluZm9AYWRkaS1kYXRhLmNvbT4KKwkqLworCXsK
KwkJLnZlbmRvciAgICAgICAgID0gUENJX1ZFTkRPUl9JRF9BRERJREFUQV9PTEQsCisJCS5kZXZp
Y2UgICAgICAgICA9IFBDSV9ERVZJQ0VfSURfQURESURBVEFfQVBDSTc4MDAsCisJCS5zdWJ2ZW5k
b3IgICAgICA9IFBDSV9BTllfSUQsCisJCS5zdWJkZXZpY2UgICAgICA9IFBDSV9BTllfSUQsCisJ
CS5zZXR1cCAgICAgICAgICA9IGFkZGlkYXRhX2FwY2k3ODAwX3NldHVwLAorCX0sCisJLyoKIAkg
KiBBRkFWTEFCIGNhcmRzIC0gdGhlc2UgbWF5IGJlIGNhbGxlZCB2aWEgcGFycG9ydF9zZXJpYWwK
IAkgKiAgSXQgaXMgbm90IGNsZWFyIHdoZXRoZXIgdGhpcyBhcHBsaWVzIHRvIGFsbCBwcm9kdWN0
cy4KIAkgKi8KQEAgLTEwMzYsNiArMTA3Miw3IEBAIGVudW0gcGNpX2JvYXJkX251bV90IHsKIAlw
Ym5fYjBfMl8xMTUyMDAsCiAJcGJuX2IwXzRfMTE1MjAwLAogCXBibl9iMF81XzExNTIwMCwKKwlw
Ym5fYjBfOF8xMTUyMDAsCiAKIAlwYm5fYjBfMV85MjE2MDAsCiAJcGJuX2IwXzJfOTIxNjAwLApA
QCAtMTE3Miw2ICsxMjA5LDEyIEBAIHN0YXRpYyBzdHJ1Y3QgcGNpc2VyaWFsX2JvYXJkIHBjaV9i
b2FyZHMKIAkJLmJhc2VfYmF1ZAk9IDExNTIwMCwKIAkJLnVhcnRfb2Zmc2V0CT0gOCwKIAl9LAor
CVtwYm5fYjBfOF8xMTUyMDBdID0geworCQkuZmxhZ3MJCT0gRkxfQkFTRTAsCisJCS5udW1fcG9y
dHMJPSA4LAorCQkuYmFzZV9iYXVkCT0gMTE1MjAwLAorCQkudWFydF9vZmZzZXQJPSA4LAorCX0s
CiAKIAlbcGJuX2IwXzFfOTIxNjAwXSA9IHsKIAkJLmZsYWdzCQk9IEZMX0JBU0UwLApAQCAtMjU3
NCw2ICsyNjE3LDk3IEBAIHN0YXRpYyBzdHJ1Y3QgcGNpX2RldmljZV9pZCBzZXJpYWxfcGNpX3QK
IAkJcGJuX3Bhc2VtaV8xNjgyTSB9LAogCiAJLyoKKwkqIEFEREktREFUQSBHbWJIIGNvbW11bmlj
YXRpb24gY2FyZHMgPGluZm9AYWRkaS1kYXRhLmNvbT4KKwkqLworCXsJUENJX1ZFTkRPUl9JRF9B
RERJREFUQSwKKwkJUENJX0RFVklDRV9JRF9BRERJREFUQV9BUENJNzUwMCwKKwkJUENJX0FOWV9J
RCwKKwkJUENJX0FOWV9JRCwKKwkJMCwKKwkJMCwKKwkJcGJuX2IwXzRfMTE1MjAwIH0sCisKKwl7
CVBDSV9WRU5ET1JfSURfQURESURBVEEsCisJCVBDSV9ERVZJQ0VfSURfQURESURBVEFfQVBDSTc0
MjAsCisJCVBDSV9BTllfSUQsCisJCVBDSV9BTllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMF8y
XzExNTIwMCB9LAorCisJewlQQ0lfVkVORE9SX0lEX0FERElEQVRBLAorCQlQQ0lfREVWSUNFX0lE
X0FERElEQVRBX0FQQ0k3MzAwLAorCQlQQ0lfQU5ZX0lELAorCQlQQ0lfQU5ZX0lELAorCQkwLAor
CQkwLAorCQlwYm5fYjBfMV8xMTUyMDAgfSwKKworCXsJUENJX1ZFTkRPUl9JRF9BRERJREFUQV9P
TEQsCisJCVBDSV9ERVZJQ0VfSURfQURESURBVEFfQVBDSTc4MDAsCisJCVBDSV9BTllfSUQsCisJ
CVBDSV9BTllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMV84XzExNTIwMCB9LAorCisJewlQQ0lf
VkVORE9SX0lEX0FERElEQVRBLAorCQlQQ0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3NTAwXzIs
CisJCVBDSV9BTllfSUQsCisJCVBDSV9BTllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMF80XzEx
NTIwMCB9LAorCisJewlQQ0lfVkVORE9SX0lEX0FERElEQVRBLAorCQlQQ0lfREVWSUNFX0lEX0FE
RElEQVRBX0FQQ0k3NDIwXzIsCisJCVBDSV9BTllfSUQsCisJCVBDSV9BTllfSUQsCisJCTAsCisJ
CTAsCisJCXBibl9iMF8yXzExNTIwMCB9LAorCisJewlQQ0lfVkVORE9SX0lEX0FERElEQVRBLAor
CQlQQ0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3MzAwXzIsCisJCVBDSV9BTllfSUQsCisJCVBD
SV9BTllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMF8xXzExNTIwMCB9LAorCisJewlQQ0lfVkVO
RE9SX0lEX0FERElEQVRBLAorCQlQQ0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3NTAwXzMsCisJ
CVBDSV9BTllfSUQsCisJCVBDSV9BTllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMF80XzExNTIw
MCB9LAorCisJewlQQ0lfVkVORE9SX0lEX0FERElEQVRBLAorCQlQQ0lfREVWSUNFX0lEX0FERElE
QVRBX0FQQ0k3NDIwXzMsCisJCVBDSV9BTllfSUQsCisJCVBDSV9BTllfSUQsCisJCTAsCisJCTAs
CisJCXBibl9iMF8yXzExNTIwMCB9LAorCisJewlQQ0lfVkVORE9SX0lEX0FERElEQVRBLAorCQlQ
Q0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3MzAwXzMsCisJCVBDSV9BTllfSUQsCisJCVBDSV9B
TllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMF8xXzExNTIwMCB9LAorCisJewlQQ0lfVkVORE9S
X0lEX0FERElEQVRBLAorCQlQQ0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3ODAwXzMsCisJCVBD
SV9BTllfSUQsCisJCVBDSV9BTllfSUQsCisJCTAsCisJCTAsCisJCXBibl9iMF84XzExNTIwMCB9
LAorCisJLyoKIAkgKiBUaGVzZSBlbnRyaWVzIG1hdGNoIGRldmljZXMgd2l0aCBjbGFzcyBDT01N
VU5JQ0FUSU9OX1NFUklBTCwKIAkgKiBDT01NVU5JQ0FUSU9OX01PREVNIG9yIENPTU1VTklDQVRJ
T05fTVVMVElTRVJJQUwKIAkgKi8K

------_=_NextPart_001_01C84218.79C9831C
Content-Type: application/octet-stream; name="pci_ids.h.patch"
Content-Transfer-Encoding: base64
Content-Description: pci_ids.h.patch
Content-Disposition: attachment; filename="pci_ids.h.patch"

LS0tIGxpbnV4LTIuNi4yMy45LXZhbmlsbGEvaW5jbHVkZS9saW51eC9wY2lfaWRzLmgJMjAwNy0x
MS0yNiAxODo1MTo0My4wMDAwMDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNi4yMy45L2luY2x1ZGUv
bGludXgvcGNpX2lkcy5oCTIwMDctMTEtMjcgMTA6NTU6MTIuMDAwMDAwMDAwICswMTAwCkBAIC0y
MDE5LDYgKzIwMTksMjMgQEAKICNkZWZpbmUgUENJX1ZFTkRPUl9JRF9RVUlDS05FVAkJMHgxNWUy
CiAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfUVVJQ0tORVRfWEoJMHgwNTAwCiAKKy8qCisgKiBBRERJ
LURBVEEgR21iSCBjb21tdW5pY2F0aW9uIGNhcmRzIDxpbmZvQGFkZGktZGF0YS5jb20+CisgKi8K
KyNkZWZpbmUgUENJX1ZFTkRPUl9JRF9BRERJREFUQV9PTEQgICAgICAgICAgICAgMHgxMEU4Cisj
ZGVmaW5lIFBDSV9WRU5ET1JfSURfQURESURBVEEgICAgICAgICAgICAgICAgIDB4MTVCOAorI2Rl
ZmluZSBQQ0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3NTAwICAgICAgICAweDcwMDAKKyNkZWZp
bmUgUENJX0RFVklDRV9JRF9BRERJREFUQV9BUENJNzQyMCAgICAgICAgMHg3MDAxCisjZGVmaW5l
IFBDSV9ERVZJQ0VfSURfQURESURBVEFfQVBDSTczMDAgICAgICAgIDB4NzAwMgorI2RlZmluZSBQ
Q0lfREVWSUNFX0lEX0FERElEQVRBX0FQQ0k3ODAwICAgICAgICAweDgxOEUKKyNkZWZpbmUgUENJ
X0RFVklDRV9JRF9BRERJREFUQV9BUENJNzUwMF8yICAgICAgMHg3MDA5CisjZGVmaW5lIFBDSV9E
RVZJQ0VfSURfQURESURBVEFfQVBDSTc0MjBfMiAgICAgIDB4NzAwQQorI2RlZmluZSBQQ0lfREVW
SUNFX0lEX0FERElEQVRBX0FQQ0k3MzAwXzIgICAgICAweDcwMEIKKyNkZWZpbmUgUENJX0RFVklD
RV9JRF9BRERJREFUQV9BUENJNzUwMF8zICAgICAgMHg3MDBDCisjZGVmaW5lIFBDSV9ERVZJQ0Vf
SURfQURESURBVEFfQVBDSTc0MjBfMyAgICAgIDB4NzAwRAorI2RlZmluZSBQQ0lfREVWSUNFX0lE
X0FERElEQVRBX0FQQ0k3MzAwXzMgICAgICAweDcwMEUKKyNkZWZpbmUgUENJX0RFVklDRV9JRF9B
RERJREFUQV9BUENJNzgwMF8zICAgICAgMHg3MDBGCisKICNkZWZpbmUgUENJX1ZFTkRPUl9JRF9Q
REMJCTB4MTVlOQogCiAjZGVmaW5lIFBDSV9WRU5ET1JfSURfRkFSU0lURSAgICAgICAgICAgMHgx
NjE5Cg==

------_=_NextPart_001_01C84218.79C9831C--
