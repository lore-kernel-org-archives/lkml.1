Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbZGWOjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbZGWOjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZGWOjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:39:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:50229 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbZGWOjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oDP8z95sh9j/AU5Y47Oj5JrCE/AbgNOQvNHDIH02OQMWBWmRXkAIEYbaYUYaJq9ciU
         u9BF7ZOxF3x0I2mUVib49SRbSgHgMEqXPuOBjBrMXATg1Ut2k89maZG8023P+uE6an7W
         UNfZuhfd1DoVpDxszDGlpv36fllt6D3FFPXWQ=
MIME-Version: 1.0
In-Reply-To: <1248351634.7237.32.camel@fnki-nb00130>
References: <1248351634.7237.32.camel@fnki-nb00130>
Date: Thu, 23 Jul 2009 07:39:12 -0700
Message-ID: <86802c440907230739ufe30b4cocc4b16faacc009c4@mail.gmail.com>
Subject: Re: early_ioremap messages with old ASUS board
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jens Rosenboom <jens@leia.mcbone.net>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd4860c8aa81c046f607393
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd4860c8aa81c046f607393
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

please try attached ...

YH

--000e0cd4860c8aa81c046f607393
Content-Type: text/x-diff; charset=US-ASCII; name="acpi_processor.patch"
Content-Disposition: attachment; filename="acpi_processor.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fxhl7sc70

W1BBVENIXSBhY3BpOiBkb24ndCBjYWxsIGFjcGlfcHJvY2Vzc29yX2luaXQgaWYgYWNwaSBpcyBk
aXNhYmxlZAoKSmVucyByZXBvcnRlZCBlYXJseV9pb3JlbWFwIG1lc3NhZ2VzIHdpdGggb2xkIEFT
VVMgYm9hcmQuLi4KCj4gWyAgICAxLjUwNzQ2MV0gcGNpIDAwMDA6MDA6MDkuMDogRmlybXdhcmUg
bGVmdCBlMTAwIGludGVycnVwdHMgZW5hYmxlZDsKPiBkaXNhYmxpbmcKPiBbICAgIDEuNTMyNzc4
XSBlYXJseV9pb3JlbWFwKDNmZmZkMDgwLCAwMDAwMDA1YykgWzBdID0+IFBpZDogMSwgY29tbToK
PiBzd2FwcGVyIE5vdCB0YWludGVkIDIuNi4zMS1yYzQgIzM2Cj4gWyAgICAxLjU2MTAwN10gQ2Fs
bCBUcmFjZToKPiBbICAgIDEuNTY4NjM4XSAgWzxjMTM2ZTQ4Yj5dID8gcHJpbnRrKzB4MTgvMHgx
ZAo+IFsgICAgMS41ODE3MzRdICBbPGMxNTUxM2ZmPl0gX19lYXJseV9pb3JlbWFwKzB4NzQvMHgx
ZTkKPiBbICAgIDEuNTk2ODk4XSAgWzxjMTU1MTVhYT5dIGVhcmx5X2lvcmVtYXArMHgxYS8weDFj
Cj4gWyAgICAxLjYxMTI3MF0gIFs8YzE1NGExODc+XSBfX2FjcGlfbWFwX3RhYmxlKzB4MTgvMHgx
YQo+IFsgICAgMS42MjY0NTFdICBbPGMxMzVhN2Y4Pl0gYWNwaV9vc19tYXBfbWVtb3J5KzB4MWQv
MHgyNQo+IFsgICAgMS42NDIxMjldICBbPGMxMTk0NTljPl0gYWNwaV90Yl92ZXJpZnlfdGFibGUr
MHgyMC8weDQ5Cj4gWyAgICAxLjY1ODMyMV0gIFs8YzExOTNlNTA+XSBhY3BpX2dldF90YWJsZV93
aXRoX3NpemUrMHg1My8weGExCj4gWyAgICAxLjY3NTU1M10gIFs8YzExOTNlYWU+XSBhY3BpX2dl
dF90YWJsZSsweDEwLzB4MTUKPiBbICAgIDEuNjkwMTkyXSAgWzxjMTU1Y2MxOT5dIGFjcGlfcHJv
Y2Vzc29yX2luaXQrMHgyMy8weGFiCj4gWyAgICAxLjcwNjEyNl0gIFs8YzEwMDEwNDM+XSBkb19v
bmVfaW5pdGNhbGwrMHgzMy8weDE4MAo+IFsgICAgMS43MjEyNzldICBbPGMxNTVjYmY2Pl0gPyBh
Y3BpX3Byb2Nlc3Nvcl9pbml0KzB4MC8weGFiCj4gWyAgICAxLjczNzQ3OV0gIFs8YzEwNjg5M2E+
XSA/IHJlZ2lzdGVyX2lycV9wcm9jKzB4YWEvMHhjMAo+IFsgICAgMS43NTM0MTFdICBbPGMxMDY4
OWI3Pl0gPyBpbml0X2lycV9wcm9jKzB4NjcvMHg4MAo+IFsgICAgMS43NjgzMTZdICBbPGMxNTQw
NWU3Pl0ga2VybmVsX2luaXQrMHgxMjAvMHgxNzYKPiBbICAgIDEuNzgyNjc4XSAgWzxjMTU0MDRj
Nz5dID8ga2VybmVsX2luaXQrMHgwLzB4MTc2Cj4gWyAgICAxLjc5NzA2Ml0gIFs8YzEwMDM4Yjc+
XSBrZXJuZWxfdGhyZWFkX2hlbHBlcisweDcvMHgxMAo+IFsgICAgMS44MTI5ODRdIDAwMDAwMDgw
ICsgZmZlMDAwMDAKCnRoYXQgaXMgcmF0aGVyIGxhdGVyLgphY3BpX2dibF9wZXJtYW5lbnRfbW1h
cCBzaG91bGQgYmUgc2V0IGluIGFjcGlfZWFybHlfaW5pdCgpCmlmIGFjcGkgaXMgbm90IGRpc2Fi
bGVkCgphbmQgd2UgaGF2ZQo+IFsgICAgMC4wMDAwMDBdIEFTVVMgUDJCLURTIGRldGVjdGVkOiBm
b3JjZSB1c2Ugb2YgYWNwaT1odAoKanVzdCBkb24ndCBsb2FkIGFjcGlfcHJvY2Vzc29yX2luaXQu
Li4KClJlcG9ydGVkLWJ5OiBKZW5zIFJvc2VuYm9vbSA8amVuc0BsZWlhLm1jYm9uZS5uZXQ+ClNp
Z25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2FjcGkvcHJvY2Vzc29yX2NvcmUuYyBiL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3Jf
Y29yZS5jCmluZGV4IDNiY2VmODIuLjAyNTlmMjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS9w
cm9jZXNzb3JfY29yZS5jCisrKyBiL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfY29yZS5jCkBAIC0x
MTM1LDYgKzExMzUsOSBAQCBzdGF0aWMgaW50IF9faW5pdCBhY3BpX3Byb2Nlc3Nvcl9pbml0KHZv
aWQpCiB7CiAJaW50IHJlc3VsdCA9IDA7CiAKKwlpZiAoYWNwaV9kaXNhYmxlZCkKKwkJcmV0dXJu
IDA7CisKIAltZW1zZXQoJmVycmF0YSwgMCwgc2l6ZW9mKGVycmF0YSkpOwogCiAjaWZkZWYgQ09O
RklHX1NNUApAQCAtMTE4Myw2ICsxMTg2LDkgQEAgb3V0X3Byb2M6CiAKIHN0YXRpYyB2b2lkIF9f
ZXhpdCBhY3BpX3Byb2Nlc3Nvcl9leGl0KHZvaWQpCiB7CisJaWYgKGFjcGlfZGlzYWJsZWQpCisJ
CXJldHVybjsKKwogCWFjcGlfcHJvY2Vzc29yX3BwY19leGl0KCk7CiAKIAlhY3BpX3RoZXJtYWxf
Y3B1ZnJlcV9leGl0KCk7Cg==
--000e0cd4860c8aa81c046f607393--
