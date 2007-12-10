Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXLJNVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXLJNVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXLJNVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:21:10 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:62575 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbXLJNVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:21:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C83B2F.76A6330B"
Subject: RE: 2.6.22.14 oops msg with commvault galaxy ?
Date: Mon, 10 Dec 2007 08:20:42 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071207171455.b2eecb60.randy.dunlap@oracle.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22.14 oops msg with commvault galaxy ?
Thread-Index: Acg5N/wX3ZMbwBQdSvmkaHSQ+29ndQB9wO4g
References: <20071207151113.e9841341.akpm@linux-foundation.org> <20071207171455.b2eecb60.randy.dunlap@oracle.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Dec 2007 13:20:42.0489 (UTC) FILETIME=[76EE4E90:01C83B2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C83B2F.76A6330B
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> -----Message d'origine-----
> De : Randy Dunlap [mailto:randy.dunlap@oracle.com]=20
> Envoy=E9 : 7 d=E9cembre 2007 20:15
>=20
> On Fri, 7 Dec 2007 15:11:13 -0800 Andrew Morton wrote:
>=20
> > On Fri, 7 Dec 2007 14:15:36 -0800
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >=20
> > > > Help would really be appreciated.
> > >=20
> > > Let's try the last_sysfs_file (name) patch.
> > > I've attempted to update it for 2.6.22.14.
> > > Andrew, does this change in fs/sysfs/file.c look OK?
> >=20
> > umm, yup.
> >=20
> >=20
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-r
> >=20
> c6/2.6.21-rc6-mm1/broken-out/gregkh-driver-sysfs-crash-debugging.patch
> >=20
> > should work.
>=20
> Thanks. =20
> I produced a cleanly applying version of it for 2.6.22.14.
>=20
> Vincent, please apply this patch so we can know which file in=20
> sysfs these oopses are happening with.
>=20

It did not applied cleanly on a 2.6.22.14... copy/paste might be the =
issue here... Anyhow, I corrected the patch failure to apply and here is =
my version of it... Hoping I got this (attached patch).

Compiling at the moment... will try this out with commvault 5.9 probably =
in the morning and get back with the results.

Let me know I got the patch wrong.

- vin

------_=_NextPart_001_01C83B2F.76A6330B
Content-Type: application/octet-stream;
	name="display_most-recently-opened_sysfs_file_name_when_oopsing.patch"
Content-Transfer-Encoding: base64
Content-Description: display_most-recently-opened_sysfs_file_name_when_oopsing.patch
Content-Disposition: attachment;
	filename="display_most-recently-opened_sysfs_file_name_when_oopsing.patch"

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjIuMTQvYXJjaC9pMzg2L2tlcm5lbC90cmFwcy5jIGxpbnV4
LTIuNi4yMi4xNC1uZXcvYXJjaC9pMzg2L2tlcm5lbC90cmFwcy5jCi0tLSBsaW51eC0yLjYuMjIu
MTQvYXJjaC9pMzg2L2tlcm5lbC90cmFwcy5jCTIwMDctMTEtMjEgMTc6MzA6NTkuMDAwMDAwMDAw
ICswMDAwCisrKyBsaW51eC0yLjYuMjIuMTQtbmV3L2FyY2gvaTM4Ni9rZXJuZWwvdHJhcHMuYwky
MDA3LTEyLTEwIDEzOjAyOjIwLjAwMDAwMDAwMCArMDAwMApAQCAtNDExLDYgKzQxMSw3IEBAIHZv
aWQgZGllKGNvbnN0IGNoYXIgKiBzdHIsIHN0cnVjdCBwdF9yZWcKICNlbmRpZgogCQlpZiAobmwp
CiAJCQlwcmludGsoIlxuIik7CisJCXN5c2ZzX3ByaW50a19sYXN0X2ZpbGUoKTsKIAkJaWYgKG5v
dGlmeV9kaWUoRElFX09PUFMsIHN0ciwgcmVncywgZXJyLAogCQkJCQljdXJyZW50LT50aHJlYWQu
dHJhcF9ubywgU0lHU0VHVikgIT0KIAkJCQlOT1RJRllfU1RPUCkgewpkaWZmIC11cHJOIGxpbnV4
LTIuNi4yMi4xNC9hcmNoL3g4Nl82NC9rZXJuZWwvdHJhcHMuYyBsaW51eC0yLjYuMjIuMTQtbmV3
L2FyY2gveDg2XzY0L2tlcm5lbC90cmFwcy5jCi0tLSBsaW51eC0yLjYuMjIuMTQvYXJjaC94ODZf
NjQva2VybmVsL3RyYXBzLmMJMjAwNy0xMS0yMSAxNzozMDo1OS4wMDAwMDAwMDAgKzAwMDAKKysr
IGxpbnV4LTIuNi4yMi4xNC1uZXcvYXJjaC94ODZfNjQva2VybmVsL3RyYXBzLmMJMjAwNy0xMi0x
MCAxMzowMzoyMi4wMDAwMDAwMDAgKzAwMDAKQEAgLTUxNiw2ICs1MTYsNyBAQCB2b2lkIF9fa3By
b2JlcyBfX2RpZShjb25zdCBjaGFyICogc3RyLCBzCiAJcHJpbnRrKCJERUJVR19QQUdFQUxMT0Mi
KTsKICNlbmRpZgogCXByaW50aygiXG4iKTsKKwlzeXNmc19wcmludGtfbGFzdF9maWxlKCk7CiAJ
bm90aWZ5X2RpZShESUVfT09QUywgc3RyLCByZWdzLCBlcnIsIGN1cnJlbnQtPnRocmVhZC50cmFw
X25vLCBTSUdTRUdWKTsKIAlzaG93X3JlZ2lzdGVycyhyZWdzKTsKIAkvKiBFeGVjdXRpdmUgc3Vt
bWFyeSBpbiBjYXNlIHRoZSBvb3BzIHNjcm9sbGVkIGF3YXkgKi8KZGlmZiAtdXByTiBsaW51eC0y
LjYuMjIuMTQvZnMvc3lzZnMvZmlsZS5jIGxpbnV4LTIuNi4yMi4xNC1uZXcvZnMvc3lzZnMvZmls
ZS5jCi0tLSBsaW51eC0yLjYuMjIuMTQvZnMvc3lzZnMvZmlsZS5jCTIwMDctMTEtMjEgMTc6MzA6
NTkuMDAwMDAwMDAwICswMDAwCisrKyBsaW51eC0yLjYuMjIuMTQtbmV3L2ZzL3N5c2ZzL2ZpbGUu
YwkyMDA3LTEyLTEwIDEzOjA0OjU1LjAwMDAwMDAwMCArMDAwMApAQCAtOCw2ICs4LDcgQEAKICNp
bmNsdWRlIDxsaW51eC9uYW1laS5oPgogI2luY2x1ZGUgPGxpbnV4L3BvbGwuaD4KICNpbmNsdWRl
IDxsaW51eC9saXN0Lmg+CisjaW5jbHVkZSA8bGludXgvbGltaXRzLmg+CiAjaW5jbHVkZSA8YXNt
L3VhY2Nlc3MuaD4KICNpbmNsdWRlIDxhc20vc2VtYXBob3JlLmg+CiAKQEAgLTE1LDYgKzE2LDEz
IEBACiAKICNkZWZpbmUgdG9fc2F0dHIoYSkgY29udGFpbmVyX29mKGEsc3RydWN0IHN1YnN5c19h
dHRyaWJ1dGUsIGF0dHIpCiAKKy8qIHVzZWQgaW4gY3Jhc2ggZHVtcHMgdG8gaGVscCB3aXRoIGRl
YnVnZ2luZyAqLworc3RhdGljIGNoYXIgbGFzdF9zeXNmc19maWxlW1BBVEhfTUFYXTsKK3ZvaWQg
c3lzZnNfcHJpbnRrX2xhc3RfZmlsZSh2b2lkKQoreworICAgICAgIHByaW50ayhLRVJOX0VNRVJH
ICJsYXN0IHN5c2ZzIGZpbGU6ICVzXG4iLCBsYXN0X3N5c2ZzX2ZpbGUpOworfQorCiAvKgogICog
U3Vic3lzdGVtIGZpbGUgb3BlcmF0aW9ucy4KICAqIFRoZXNlIG9wZXJhdGlvbnMgYWxsb3cgc3Vi
c3lzdGVtcyB0byBoYXZlIGZpbGVzIHRoYXQgY2FuIGJlIApAQCAtMjUzLDYgKzI2MSwxMiBAQCBz
dGF0aWMgaW50IHN5c2ZzX29wZW5fZmlsZShzdHJ1Y3QgaW5vZGUgCiAJc3RydWN0IHN5c2ZzX2J1
ZmZlciAqIGJ1ZmZlcjsKIAlzdHJ1Y3Qgc3lzZnNfb3BzICogb3BzID0gTlVMTDsKIAlpbnQgZXJy
b3IgPSAwOworCWNoYXIgKnA7CisKKwlwID0gZF9wYXRoKGZpbGUtPmZfZGVudHJ5LCBzeXNmc19t
b3VudCwgbGFzdF9zeXNmc19maWxlLAorCQkgICBzaXplb2YobGFzdF9zeXNmc19maWxlKSk7CisJ
aWYgKHApCisJCW1lbW1vdmUobGFzdF9zeXNmc19maWxlLCBwLCBzdHJsZW4ocCkgKyAxKTsKIAog
CWlmICgha29iaiB8fCAhYXR0cikKIAkJZ290byBFaW52YWw7CmRpZmYgLXVwck4gbGludXgtMi42
LjIyLjE0L2luY2x1ZGUvbGludXgvc3lzZnMuaCBsaW51eC0yLjYuMjIuMTQtbmV3L2luY2x1ZGUv
bGludXgvc3lzZnMuaAotLS0gbGludXgtMi42LjIyLjE0L2luY2x1ZGUvbGludXgvc3lzZnMuaAky
MDA3LTExLTIxIDE3OjMwOjU5LjAwMDAwMDAwMCArMDAwMAorKysgbGludXgtMi42LjIyLjE0LW5l
dy9pbmNsdWRlL2xpbnV4L3N5c2ZzLmgJMjAwNy0xMi0xMCAxMzowMDoyMC4wMDAwMDAwMDAgKzAw
MDAKQEAgLTEyNSw2ICsxMjUsNyBAQCB2b2lkIHN5c2ZzX3JlbW92ZV9maWxlX2Zyb21fZ3JvdXAo
c3RydWN0CiAJCWNvbnN0IHN0cnVjdCBhdHRyaWJ1dGUgKmF0dHIsIGNvbnN0IGNoYXIgKmdyb3Vw
KTsKIAogdm9pZCBzeXNmc19ub3RpZnkoc3RydWN0IGtvYmplY3QgKiBrLCBjaGFyICpkaXIsIGNo
YXIgKmF0dHIpOwordm9pZCBzeXNmc19wcmludGtfbGFzdF9maWxlKHZvaWQpOwogCiAKIGV4dGVy
biBpbnQgc3lzZnNfbWFrZV9zaGFkb3dlZF9kaXIoc3RydWN0IGtvYmplY3QgKmtvYmosCkBAIC0y
NDAsNiArMjQxLDExIEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fbXVzdF9jaGVjayBzeXNmc19pbmkK
IAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGlubGluZSB2b2lkIHN5c2ZzX3ByaW50a19sYXN0X2Zp
bGUodm9pZCkKK3sKKyAgICAgICA7Cit9CisKICNlbmRpZiAvKiBDT05GSUdfU1lTRlMgKi8KIAog
I2VuZGlmIC8qIF9TWVNGU19IXyAqLwo=

------_=_NextPart_001_01C83B2F.76A6330B--
