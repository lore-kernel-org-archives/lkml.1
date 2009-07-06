Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZGFXFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZGFXFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZGFXF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:05:26 -0400
Received: from eta-ori.net ([91.121.142.51]:40764 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZGFXFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:05:25 -0400
Message-ID: <4A528337.10005@impulze.org>
Date: Tue, 07 Jul 2009 01:05:27 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090628)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Re: Parsing kernel parameters and escaping "
References: <4A50B09B.9030901@impulze.org> <4A5282B4.8070302@impulze.org>
In-Reply-To: <4A5282B4.8070302@impulze.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigACFFE4EDD9541FEA54982D47"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigACFFE4EDD9541FEA54982D47
Content-Type: multipart/mixed;
 boundary="------------050405010605050001010604"

This is a multi-part message in MIME format.
--------------050405010605050001010604
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Daniel Mierswa wrote:
> As stated in my last E-Mail in this thread there are currently some
> limitations when passing quotes to kernel parameters, I tried to remove=

> some of those limitations. A git fp is attached.
>=20
> (from the commit message):
>> There was a limitation for kernel parameters with regards to quoting. =
It
>> wasn't possible to escape quotes or use quotes to form space-filled
>> values _inside_ parameters. This patch attempts to make that possible,=

>> kernel parameters are now parsed as follows:
>> '"param=3D value"' [param=3D value][]
>> 'param=3D" value "" combination "' [param][ value  combination ]
>> 'param=3D" \" test"' [param][ " test]
>> '"param"=3Danother' [param][another]
>=20
> Any suggestions welcome. Please be kind, as I'm not too familar with
> writing parsers, kernel development and what I may have broke. :-)
>=20

Great I forgot the patch, here it is now.

--=20
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22

--------------050405010605050001010604
Content-Type: text/plain;
 name="kernel.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="kernel.patch"

RnJvbSAyZGJjMTI0YjZjMTY3NDU5MmVjNWZhYWFlNWNhODdmYzdiMTZjYzEyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYW5pZWwgTWllcnN3YSA8aW1wdWx6ZUBpbXB1bHpl
Lm9yZz4KRGF0ZTogVHVlLCA3IEp1bCAyMDA5IDAwOjU0OjM4ICswMjAwClN1YmplY3Q6IFtQ
QVRDSF0gQXR0ZW1wdCB0byBoYW5kbGUgcXVvdGVzIGluIGtlcm5lbCBwYXJhbWV0ZXJzCgpU
aGVyZSB3YXMgYSBsaW1pdGF0aW9uIGZvciBrZXJuZWwgcGFyYW1ldGVycyB3aXRoIHJlZ2Fy
ZHMgdG8gcXVvdGluZy4gSXQKd2Fzbid0IHBvc3NpYmxlIHRvIGVzY2FwZSBxdW90ZXMgb3Ig
dXNlIHF1b3RlcyB0byBmb3JtIHNwYWNlLWZpbGxlZAp2YWx1ZXMgX2luc2lkZV8gcGFyYW1l
dGVycy4gVGhpcyBwYXRjaCBhdHRlbXB0cyB0byBtYWtlIHRoYXQgcG9zc2libGUsCmtlcm5l
bCBwYXJhbWV0ZXJzIGFyZSBub3cgcGFyc2VkIGFzIGZvbGxvd3M6CicicGFyYW09IHZhbHVl
IicgW3BhcmFtPSB2YWx1ZV1bXQoncGFyYW09IiB2YWx1ZSAiIiBjb21iaW5hdGlvbiAiJyBb
cGFyYW1dWyB2YWx1ZSAgY29tYmluYXRpb24gXQoncGFyYW09IiBcIiB0ZXN0IicgW3BhcmFt
XVsgIiB0ZXN0XQonInBhcmFtIj1hbm90aGVyJyBbcGFyYW1dW2Fub3RoZXJdCi0tLQoga2Vy
bmVsL3BhcmFtcy5jIHwgIDEzNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDkzIGluc2VydGlvbnMo
KyksIDQyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9wYXJhbXMuYyBiL2tl
cm5lbC9wYXJhbXMuYwppbmRleCBkZTI3M2VjLi4wYTlmYzE0IDEwMDY0NAotLS0gYS9rZXJu
ZWwvcGFyYW1zLmMKKysrIGIva2VybmVsL3BhcmFtcy5jCkBAIC03NSw1OCArNzUsMTA5IEBA
IHN0YXRpYyBpbnQgcGFyc2Vfb25lKGNoYXIgKnBhcmFtLAogCXJldHVybiAtRU5PRU5UOwog
fQogCi0vKiBZb3UgY2FuIHVzZSAiIGFyb3VuZCBzcGFjZXMsIGJ1dCBjYW4ndCBlc2NhcGUg
Ii4gKi8KLS8qIEh5cGhlbnMgYW5kIHVuZGVyc2NvcmVzIGVxdWl2YWxlbnQgaW4gcGFyYW1l
dGVyIG5hbWVzLiAqLwotc3RhdGljIGNoYXIgKm5leHRfYXJnKGNoYXIgKmFyZ3MsIGNoYXIg
KipwYXJhbSwgY2hhciAqKnZhbCkKKy8qIGhhbmRsZSBxdW90ZXMgaW4gdG9rZW5zIChwYXJh
bWV0ZXIgYW5kIHZhbHVlcykKKyAqICciIGZvbyBiYXIgIicgPT4gJyBmb28gYmFyICcKKyAq
ICciIGZvbyBcIiAiJyAgPT4gJyBmb28gIiAnCisgKi8KK3N0YXRpYyB2b2lkIGFkZF90b2tl
bihjaGFyICoqIHRva2VuLCBjaGFyICogYXJncykKIHsKLQl1bnNpZ25lZCBpbnQgaSwgZXF1
YWxzID0gMDsKLQlpbnQgaW5fcXVvdGUgPSAwLCBxdW90ZWQgPSAwOwotCWNoYXIgKm5leHQ7
CisJY2hhciAqIGl0ZXJhdG9yLCAqIGxhc3RfcXVvdGU7CisJaW50IGluX3F1b3RlczsKIAot
CWlmICgqYXJncyA9PSAnIicpIHsKLQkJYXJncysrOwotCQlpbl9xdW90ZSA9IDE7Ci0JCXF1
b3RlZCA9IDE7CisJaW5fcXVvdGVzID0gMDsKKworCWZvciAoaXRlcmF0b3IgPSBhcmdzOyAq
aXRlcmF0b3I7IGl0ZXJhdG9yKyspIHsKKwkJaWYgKCppdGVyYXRvciA9PSAnXFwnICYmICoo
aXRlcmF0b3IgKyAxKSA9PSAnIicpIHsKKwkJCWNoYXIgKiBtb3ZlcjsKKworCQkJLyogbW92
ZSBhbGwgY2hhcmFjdGVycyBiYWNrICovCisJCQlmb3IgKG1vdmVyID0gaXRlcmF0b3I7ICpt
b3ZlcjsgbW92ZXIrKykgeworCQkJCSptb3ZlciA9ICoobW92ZXIgKyAxKTsKKwkJCX0KKwor
CQkJY29udGludWU7CisJCX0KKworCQlpZiAoKml0ZXJhdG9yICE9ICciJykgeworCQkJY29u
dGludWU7CisJCX0KKworCQlpZiAoaW5fcXVvdGVzKSB7CisJCQljaGFyICogbW92ZXI7CisK
KwkJCS8qIG1vdmUgd2hvbGUgc3RyaW5nIGJhY2sgdW50aWwgY3VycmVudCAiIGlzIHJlYWNo
ZWQgKi8KKwkJCWZvciAobW92ZXIgPSBsYXN0X3F1b3RlOyBtb3ZlciAhPSBpdGVyYXRvciAt
IDE7IG1vdmVyKyspIHsKKwkJCQkqbW92ZXIgPSAqKG1vdmVyICsgMSk7CisJCQl9CisKKwkJ
CS8qIGlnbm9yZSB0aGUgY3VycmVudCAiIGFuZCBtb3ZlIHRoZSByZXN0IG9mIHRoZSBzdHJp
bmcgYmFjayAqLworCQkJd2hpbGUgKCptb3ZlcikgeworCQkJCSptb3ZlciA9ICoobW92ZXIg
KyAyKTsKKwkJCQltb3ZlcisrOworCQkJfQorCisJCQkvKiBpZ25vcmVkIDIgcXVvdGVzLCBk
ZWNyZWFzZSB0aGUgaXRlcmF0b3IgKi8KKwkJCWl0ZXJhdG9yIC09IDI7CisJCQlsYXN0X3F1
b3RlID0gTlVMTDsKKwkJfSBlbHNlIHsKKwkJCWxhc3RfcXVvdGUgPSBpdGVyYXRvcjsKKwkJ
fQorCisJCWluX3F1b3RlcyA9ICFpbl9xdW90ZXM7CiAJfQogCi0JZm9yIChpID0gMDsgYXJn
c1tpXTsgaSsrKSB7Ci0JCWlmIChhcmdzW2ldID09ICcgJyAmJiAhaW5fcXVvdGUpCisJKnRv
a2VuID0gYXJnczsKK30KKworc3RhdGljIGNoYXIgKiBuZXh0X2FyZyhjaGFyICogYXJncywg
Y2hhciAqKiBwYXJhbSwgY2hhciAqKiB2YWwpCit7CisJY2hhciAqIHRva2VuOworCWludCBp
bl9xdW90ZXMsIGlzX2VzY2FwZWQ7CisKKwkqcGFyYW0gPSAqdmFsID0gTlVMTDsKKwlpbl9x
dW90ZXMgPSBpc19lc2NhcGVkID0gMDsKKworCS8qIHRva2VuaXplciAqLworCWZvciAodG9r
ZW4gPSBhcmdzOyAqdG9rZW47IHRva2VuKyspIHsKKwkJLyogcGFyYW1ldGVyIG9yIHZhbHVl
IGlzIGZpbmlzaGVkICovCisJCWlmICghaW5fcXVvdGVzICYmICp0b2tlbiA9PSAnICcpIHsK
KwkJCSp0b2tlbiA9ICdcMCc7CiAJCQlicmVhazsKLQkJaWYgKGVxdWFscyA9PSAwKSB7Ci0J
CQlpZiAoYXJnc1tpXSA9PSAnPScpCi0JCQkJZXF1YWxzID0gaTsKIAkJfQotCQlpZiAoYXJn
c1tpXSA9PSAnIicpCi0JCQlpbl9xdW90ZSA9ICFpbl9xdW90ZTsKLQl9CiAKLQkqcGFyYW0g
PSBhcmdzOwotCWlmICghZXF1YWxzKQotCQkqdmFsID0gTlVMTDsKLQllbHNlIHsKLQkJYXJn
c1tlcXVhbHNdID0gJ1wwJzsKLQkJKnZhbCA9IGFyZ3MgKyBlcXVhbHMgKyAxOwotCi0JCS8q
IERvbid0IGluY2x1ZGUgcXVvdGVzIGluIHZhbHVlLiAqLwotCQlpZiAoKip2YWwgPT0gJyIn
KSB7Ci0JCQkoKnZhbCkrKzsKLQkJCWlmIChhcmdzW2ktMV0gPT0gJyInKQotCQkJCWFyZ3Nb
aS0xXSA9ICdcMCc7CisJCS8qIHBhcmFtZXRlci92YWx1ZSBzcGxpdCAqLworCQlpZiAoIWlu
X3F1b3RlcyAmJiAqdG9rZW4gPT0gJz0nICYmICEqcGFyYW0pIHsKKwkJCSp0b2tlbiA9ICdc
MCc7CisJCQlhZGRfdG9rZW4ocGFyYW0sIGFyZ3MpOworCQkJYXJncyA9IHRva2VuICsgMTsK
KwkJCWNvbnRpbnVlOworCQl9CisKKwkJaWYgKCFpc19lc2NhcGVkICYmICp0b2tlbiA9PSAn
XFwnKSB7CisJCQlpc19lc2NhcGVkID0gMTsKKwkJCWNvbnRpbnVlOwogCQl9Ci0JCWlmIChx
dW90ZWQgJiYgYXJnc1tpLTFdID09ICciJykKLQkJCWFyZ3NbaS0xXSA9ICdcMCc7CisKKwkJ
aWYgKCp0b2tlbiA9PSAnIicgJiYgIWlzX2VzY2FwZWQpIHsKKwkJCWluX3F1b3RlcyA9ICFp
bl9xdW90ZXM7CisJCX0KKworCQkvKiBhbHdheXMgcmVzZXQgZXNjYXBlIHZhbHVlLCBvbmx5
ICIgbmVlZHMgaXQgKi8KKwkJaXNfZXNjYXBlZCA9IDA7CiAJfQogCi0JaWYgKGFyZ3NbaV0p
IHsKLQkJYXJnc1tpXSA9ICdcMCc7Ci0JCW5leHQgPSBhcmdzICsgaSArIDE7Ci0JfSBlbHNl
Ci0JCW5leHQgPSBhcmdzICsgaTsKKwlpZiAoISpwYXJhbSkgeworCQlhZGRfdG9rZW4ocGFy
YW0sIGFyZ3MpOworCX0gZWxzZSB7CisJCWFkZF90b2tlbih2YWwsIGFyZ3MpOworCX0KKwor
CS8qIHJlbW92ZSB0cmFpbGluZyBzcGFjZXMgKi8KKwl3aGlsZSAoKnRva2VuID09ICcgJykg
eworCQl0b2tlbisrOworCX0KIAotCS8qIENoZXcgdXAgdHJhaWxpbmcgc3BhY2VzLiAqLwot
CXdoaWxlICgqbmV4dCA9PSAnICcpCi0JCW5leHQrKzsKLQlyZXR1cm4gbmV4dDsKKwlyZXR1
cm4gdG9rZW4gKyAxOwogfQogCiAvKiBBcmdzIGxvb2tzIGxpa2UgImZvbz1iYXIsYmFyMiBi
YXo9ZnV6IHdpeiIuICovCi0tIAoxLjYuMy4zCgo=
--------------050405010605050001010604--

--------------enigACFFE4EDD9541FEA54982D47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkpSgzcACgkQm9l44K3zL5cs6wCaAmWc8tLv4OGUNzN7ykxSnczA
8ksAn2katf+2JRwI0j3GdkSjV076RA8m
=gH4b
-----END PGP SIGNATURE-----

--------------enigACFFE4EDD9541FEA54982D47--
