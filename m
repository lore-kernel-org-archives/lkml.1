Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXJNLib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXJNLib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 07:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXJNLiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 07:38:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:59209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbXJNLiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 07:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=aIhKfEbSmXCd+bfJdukQbWCf8uPPDYEgnLPKD3ZiTdPcBxWZ33dso0y0pnXb6/E33a85ZW7kwv8DuZhnr4HrJvYvIqK8YUNFe76r8ccY5vMmHCFkKjJCY/ouOjR+9s9nlu2lQNwLWWh6zCIhxdNDvVeYqU4GBzMJHq7i6FLtswQ=
Message-ID: <21d7e9970710140438p3e1c176et6c33ed4d7738364e@mail.gmail.com>
Date: Sun, 14 Oct 2007 21:38:22 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>
Subject: Re: 2.6.23(.1) Regression? i915 oopses and panics
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fesrv9$o97$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_28197_31742048.1192361902160"
References: <fesqkn$lml$1@ger.gmane.org>
	 <21d7e9970710140341i25afc47cwdd9e441a0d2e2d0f@mail.gmail.com>
	 <fesrv9$o97$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_28197_31742048.1192361902160
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 10/14/07, Thomas B=E4chler <thomas@archlinux.org> wrote:
> Dave Airlie schrieb:
> > lets start with:
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3De4a7b1d1d90d202a030688ab5b177c3c0f15ee3e
> >
> > and work from there..
>
> I'm sorry, I forgot to mention that: As I _thought_ it had worked with
> rc6, I already found that commit. I reverted it and got a panic again
> (no trace, as I was in X), so this one doesn't seem to cause the problem.
>

Okay I've spotted a potential bug that might lay hidden, try the
attached patch to see if it helps..

Dave.

------=_Part_28197_31742048.1192361902160
Content-Type: text/x-patch;
 name="0001-i915-fix-vbl-swap-allocation-size.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="0001-i915-fix-vbl-swap-allocation-size.patch";
 filename="0001-i915-fix-vbl-swap-allocation-size.patch"
X-Attachment-Id: f_f7rhgm8o

RnJvbSA3YzYzYWU0NTI3MzU1ZDhmNTJkYzI4NWE5MTYzYTU5NDdhNjE1NzJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBTdW4sIDE0IE9jdCAyMDA3IDIxOjIxOjMwICsxMDAwClN1YmplY3Q6IFtQQVRDSF0gaTkxNTog
Zml4IHZibCBzd2FwIGFsbG9jYXRpb24gc2l6ZS4KCk9vcHMuLi4KClNpZ25lZC1vZmYtYnk6IERh
dmUgQWlybGllIDxhaXJsaWVkQGxpbnV4LmllPgotLS0KIGRyaXZlcnMvY2hhci9kcm0vaTkxNV9p
cnEuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9kcm0vaTkxNV9pcnEuYyBiL2RyaXZl
cnMvY2hhci9kcm0vaTkxNV9pcnEuYwppbmRleCBiYjhlOWU5Li45NGQ2MzhlIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2NoYXIvZHJtL2k5MTVfaXJxLmMKKysrIGIvZHJpdmVycy9jaGFyL2RybS9pOTE1
X2lycS5jCkBAIC01NTMsNyArNTUzLDcgQEAgaW50IGk5MTVfdmJsYW5rX3N3YXAoRFJNX0lPQ1RM
X0FSR1MpCiAJCXJldHVybiBEUk1fRVJSKEVCVVNZKTsKIAl9CiAKLQl2Ymxfc3dhcCA9IGRybV9j
YWxsb2MoMSwgc2l6ZW9mKHZibF9zd2FwKSwgRFJNX01FTV9EUklWRVIpOworCXZibF9zd2FwID0g
ZHJtX2NhbGxvYygxLCBzaXplb2YoKnZibF9zd2FwKSwgRFJNX01FTV9EUklWRVIpOwogCiAJaWYg
KCF2Ymxfc3dhcCkgewogCQlEUk1fRVJST1IoIkZhaWxlZCB0byBhbGxvY2F0ZSBtZW1vcnkgdG8g
cXVldWUgc3dhcFxuIik7Ci0tIAoxLjUuMi40Cgo=
------=_Part_28197_31742048.1192361902160--
