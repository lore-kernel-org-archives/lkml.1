Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXFLSux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXFLSux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbXFLSuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:50:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:5664 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbXFLSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=WcUqZmSVUqtzCp8qSuF4hKuy4D82L6guv2OmKIBB0V9FzAarmxKlgb9LoLBSyhiDbILZYMKxahoya8hvP4btyCPir5TCCHmygLiDVsi80a7mQLAegRgL2xUdOyECUxrFxMzWtvegKWAWzb2wUZH3Or/LeQSFi095nPp/yDkIOfk=
Message-ID: <d120d5000706121150p56a581d3je6d9a886529b591@mail.gmail.com>
Date: Tue, 12 Jun 2007 14:50:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Albrecht" <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1181656946.3176.1.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10692_4406116.1181674242116"
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com>
	 <1181588095.2436.5.camel@albrecht.rdi1.com>
	 <200706120114.48645.dtor@insightbb.com>
	 <1181656946.3176.1.camel@albrecht.rdi1.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10692_4406116.1181674242116
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 6/12/07, Paul Albrecht <albrecht@rdi1.com> wrote:
> On Tue, 2007-06-12 at 01:14 -0400, Dmitry Torokhov wrote:
> > On Monday 11 June 2007 14:54, Paul Albrecht wrote:
> > >
> > > Is i8042.noaux a workaround or a fix?
> > >
> >
> > Just a workaround. Do you have a PS/2 mouse you could test with? If so could
> > you check if both keybioard and mouse work with mouse plugged in and without
> > i8042.noaux.
> >
>
> The system I'm using has only one ps/2 interface so I can't test with
> them both plugged in at the same time.
>
> > Also cxould you please try the patch below (again with mouse if you have one
> > and without).
> >
>
> I tried applying your patch to 2.6.21.5 and it failed. Here's the
> output:
>
> patch --dry-run -p1 < ../i8042.patch
> patching file drivers/input/serio/i8042-x86ia64io.h
> Hunk #1 FAILED at 356.
> Hunk #2 FAILED at 404.
> 2 out of 2 hunks FAILED -- saving rejects to file
> drivers/input/serio/i8042-x86ia64io.h.rej
>

Hmm, wierd:

[~] tar jxf downloads/linux-2.6.21.5.tar.bz2
[~] cd linux-2.6.21.5/
[~/linux-2.6.21.5] patch -p1 --dry-run < ../quilt/i8042-trust-pnp-more.patch
patching file drivers/input/serio/i8042-x86ia64io.h
Hunk #1 succeeded at 313 (offset -43 lines).
Hunk #2 succeeded at 361 (offset -43 lines).
[~/linux-2.6.21.5]

The patch must have gotten corrupted on the way to you. Let me try
resending it, but this time as an attachment.

-- 
Dmitry

------=_Part_10692_4406116.1181674242116
Content-Type: text/plain; name=i8042-trust-pnp-more.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2uqblfo
Content-Disposition: attachment; filename="i8042-trust-pnp-more.patch"

SW5wdXQ6IGk4MDQyIC0gZ2l2ZSBtb3JlIHRydXN0IFBOUCBkYXRhIG9uIGkzODYKCk9uIHNvbWUg
Ym94ZXMgdGhhdCBkb24ndCBoYXZlIFBTLzIgbWljZSBjb25uZWN0ZWQgYXQgc3RhcnR1cCBCSU9T
CmNvbXBsZXRlbHkgZGlzYWJsZXMgQVVYIHBvcnQgYW5kIGF0dGVtcHRzIHRvIGFjY2VzcyBpdCBy
ZXN1bHQgaW4KaG9zZWQga2V5Ym9hcmQuIEhpc3RvcmljYWxseSB3ZSBkbyBub3QgdHJ1c3QgQUNQ
SS9QTlAgZGF0YSBvbgppMzg2IGFuZCB0cnkgdG8gcG9rZSBBVVggcG9ydCBldmVuIGlmIHdlIGRp
ZCBub3QgZmluZCBhbiBhY3RpdmUKUE5QIG5vZGUgZm9yIGl0LiBIb3dldmVyIGluIGNhc2VzIHdo
ZW4gQklPUyB3cml0ZXJzIGdvdCBLQkQgcG9ydApwcm9wZXJseSBkZXNjcmliZWQgd2UgY2FuIGFz
c3VtZSB0aGF0IHRoZXkgZGlkIHRoZSByaWdodCB0aGluZwpmb3IgQVVYIHBvcnQgYXMgd2VsbC4K
ClNpZ25lZC1vZmYtYnk6IERtaXRyeSBUb3Jva2hvdiA8ZHRvckBtYWlsLnJ1PgotLS0KIGRyaXZl
cnMvaW5wdXQvc2VyaW8vaTgwNDIteDg2aWE2NGlvLmggfCAgIDM2ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA3IGRl
bGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4L2RyaXZlcnMvaW5wdXQvc2VyaW8vaTgwNDIteDg2aWE2
NGlvLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gbGludXgub3JpZy9kcml2ZXJzL2lucHV0L3NlcmlvL2k4MDQy
LXg4NmlhNjRpby5oCisrKyBsaW51eC9kcml2ZXJzL2lucHV0L3NlcmlvL2k4MDQyLXg4NmlhNjRp
by5oCkBAIC0zNTYsNiArMzU2LDcgQEAgc3RhdGljIHZvaWQgaTgwNDJfcG5wX2V4aXQodm9pZCkK
IHN0YXRpYyBpbnQgX19pbml0IGk4MDQyX3BucF9pbml0KHZvaWQpCiB7CiAJY2hhciBrYmRfaXJx
X3N0cls0XSA9IHsgMCB9LCBhdXhfaXJxX3N0cls0XSA9IHsgMCB9OworCWludCBwbnBfZGF0YV9i
dXN0ZWQgPSAwOwogCWludCBlcnI7CiAKIAlpZiAoaTgwNDJfbm9wbnApIHsKQEAgLTQwMywyNyAr
NDA0LDQ4IEBAIHN0YXRpYyBpbnQgX19pbml0IGk4MDQyX3BucF9pbml0KHZvaWQpCiAjZW5kaWYK
IAogCWlmICgoKGk4MDQyX3BucF9kYXRhX3JlZyAmIH4weGYpID09IChpODA0Ml9kYXRhX3JlZyAm
IH4weGYpICYmCi0JICAgICAgaTgwNDJfcG5wX2RhdGFfcmVnICE9IGk4MDQyX2RhdGFfcmVnKSB8
fCAhaTgwNDJfcG5wX2RhdGFfcmVnKSB7Ci0JCXByaW50ayhLRVJOX1dBUk5JTkcgIlBOUDogUFMv
MiBjb250cm9sbGVyIGhhcyBpbnZhbGlkIGRhdGEgcG9ydCAlI3g7IHVzaW5nIGRlZmF1bHQgJSN4
XG4iLAorCSAgICAgIGk4MDQyX3BucF9kYXRhX3JlZyAhPSBpODA0Ml9kYXRhX3JlZykgfHwKKwkg
ICAgIWk4MDQyX3BucF9kYXRhX3JlZykgeworCQlwcmludGsoS0VSTl9XQVJOSU5HCisJCQkiUE5Q
OiBQUy8yIGNvbnRyb2xsZXIgaGFzIGludmFsaWQgZGF0YSBwb3J0ICUjeDsgIgorCQkJInVzaW5n
IGRlZmF1bHQgJSN4XG4iLAogCQkJaTgwNDJfcG5wX2RhdGFfcmVnLCBpODA0Ml9kYXRhX3JlZyk7
CiAJCWk4MDQyX3BucF9kYXRhX3JlZyA9IGk4MDQyX2RhdGFfcmVnOworCQlwbnBfZGF0YV9idXN0
ZWQgPSAxOwogCX0KIAogCWlmICgoKGk4MDQyX3BucF9jb21tYW5kX3JlZyAmIH4weGYpID09IChp
ODA0Ml9jb21tYW5kX3JlZyAmIH4weGYpICYmCi0JICAgICAgaTgwNDJfcG5wX2NvbW1hbmRfcmVn
ICE9IGk4MDQyX2NvbW1hbmRfcmVnKSB8fCAhaTgwNDJfcG5wX2NvbW1hbmRfcmVnKSB7Ci0JCXBy
aW50ayhLRVJOX1dBUk5JTkcgIlBOUDogUFMvMiBjb250cm9sbGVyIGhhcyBpbnZhbGlkIGNvbW1h
bmQgcG9ydCAlI3g7IHVzaW5nIGRlZmF1bHQgJSN4XG4iLAorCSAgICAgIGk4MDQyX3BucF9jb21t
YW5kX3JlZyAhPSBpODA0Ml9jb21tYW5kX3JlZykgfHwKKwkgICAgIWk4MDQyX3BucF9jb21tYW5k
X3JlZykgeworCQlwcmludGsoS0VSTl9XQVJOSU5HCisJCQkiUE5QOiBQUy8yIGNvbnRyb2xsZXIg
aGFzIGludmFsaWQgY29tbWFuZCBwb3J0ICUjeDsgIgorCQkJInVzaW5nIGRlZmF1bHQgJSN4XG4i
LAogCQkJaTgwNDJfcG5wX2NvbW1hbmRfcmVnLCBpODA0Ml9jb21tYW5kX3JlZyk7CiAJCWk4MDQy
X3BucF9jb21tYW5kX3JlZyA9IGk4MDQyX2NvbW1hbmRfcmVnOworCQlwbnBfZGF0YV9idXN0ZWQg
PSAxOwogCX0KIAogCWlmICghaTgwNDJfbm9rYmQgJiYgIWk4MDQyX3BucF9rYmRfaXJxKSB7Ci0J
CXByaW50ayhLRVJOX1dBUk5JTkcgIlBOUDogUFMvMiBjb250cm9sbGVyIGRvZXNuJ3QgaGF2ZSBL
QkQgaXJxOyB1c2luZyBkZWZhdWx0ICVkXG4iLCBpODA0Ml9rYmRfaXJxKTsKKwkJcHJpbnRrKEtF
Uk5fV0FSTklORworCQkJIlBOUDogUFMvMiBjb250cm9sbGVyIGRvZXNuJ3QgaGF2ZSBLQkQgaXJx
OyAiCisJCQkidXNpbmcgZGVmYXVsdCAlZFxuIiwgaTgwNDJfa2JkX2lycSk7CiAJCWk4MDQyX3Bu
cF9rYmRfaXJxID0gaTgwNDJfa2JkX2lycTsKKwkJcG5wX2RhdGFfYnVzdGVkID0gMTsKIAl9CiAK
IAlpZiAoIWk4MDQyX25vYXV4ICYmICFpODA0Ml9wbnBfYXV4X2lycSkgewotCQlwcmludGsoS0VS
Tl9XQVJOSU5HICJQTlA6IFBTLzIgY29udHJvbGxlciBkb2Vzbid0IGhhdmUgQVVYIGlycTsgdXNp
bmcgZGVmYXVsdCAlZFxuIiwgaTgwNDJfYXV4X2lycSk7Ci0JCWk4MDQyX3BucF9hdXhfaXJxID0g
aTgwNDJfYXV4X2lycTsKKwkJaWYgKCFwbnBfZGF0YV9idXN0ZWQgJiYgaTgwNDJfcG5wX2tiZF9p
cnEpIHsKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcKKwkJCQkiUE5QOiBQUy8yIGFwcGVhcnMgdG8g
aGF2ZSBBVVggcG9ydCBkaXNhYmxlZCwgIgorCQkJCSJpZiB0aGlzIGlzIGluY29ycmVjdCBwbGVh
c2UgYm9vdCB3aXRoICIKKwkJCQkiaTgwNDIubm9wbnBcbiIpOworCQkJaTgwNDJfbm9hdXggPSAx
OworCQl9IGVsc2UgeworCQkJcHJpbnRrKEtFUk5fV0FSTklORworCQkJCSJQTlA6IFBTLzIgY29u
dHJvbGxlciBkb2Vzbid0IGhhdmUgQVVYIGlycTsgIgorCQkJCSJ1c2luZyBkZWZhdWx0ICVkXG4i
LCBpODA0Ml9hdXhfaXJxKTsKKwkJCWk4MDQyX3BucF9hdXhfaXJxID0gaTgwNDJfYXV4X2lycTsK
KwkJfQogCX0KIAogCWk4MDQyX2RhdGFfcmVnID0gaTgwNDJfcG5wX2RhdGFfcmVnOwo=
------=_Part_10692_4406116.1181674242116--
