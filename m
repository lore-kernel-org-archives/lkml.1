Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZCDVs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZCDVs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZCDVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:48:46 -0500
Received: from tlrextaddr2.trane.com ([65.248.77.5]:42077 "EHLO
	tlrextaddr2.trane.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbZCDVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:48:45 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2009 16:48:44 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C99D10.DD7175B1"
Subject: [PATCH] nand_bbt.c, kernel 2.6.28.7
Date: Wed, 4 Mar 2009 15:33:32 -0600
Message-ID: <530D814CA877134987D5272AB845371402AC7FD9@TWCUSMS1249.am.corp.priv>
In-Reply-To: <E1LerZg-0000Rp-AX@mailer.emlix.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] nand_bbt.c, kernel 2.6.28.7
Thread-Index: Acmc0RO4whS52MwURAacyU82QxCYNAAPgoOA
References: <E1LerZg-0000Rp-AX@mailer.emlix.com>
From: "Basterash, Tom" <TBasterash@trane.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Mar 2009 21:33:33.0065 (UTC) FILETIME=[DE419F90:01C99D10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C99D10.DD7175B1
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

New to the Linux kernel development community here...

This is a patch for a bug I found in an older version of the kernel I'm
using on a project (2.6.10).  (The defect still exists in the latest
version of the kernel 2.6.28.7, hence the reason for the post.)  For
NAND chips with large block sizes (128K in our case) I was getting an
out of memory error when I attempted to store the bad block table in
flash.  This patch fixes that error by allocating memory in the same way
it's done in another function in the file.  Feedback desired: Does the
fix seem reasonable?  If so, what else must be done to have it
incorporated into the source tree?  Thx.
The information contained in this message is privileged and intended only=
 for the recipients named. If the reader is not a representative of the i=
ntended recipient, any review, dissemination or copying of this message o=
r the information it contains is prohibited. If you have received this me=
ssage in error, please immediately notify the sender, and delete the orig=
inal message and attachments.

------_=_NextPart_001_01C99D10.DD7175B1
Content-Type: application/octet-stream;
	name="nand_bbt.patch"
Content-Transfer-Encoding: base64
Content-Description: nand_bbt.patch
Content-Disposition: attachment;
	filename="nand_bbt.patch"

LS0tIGxpbnV4LTIuNi4yOC43L29yaWcvZHJpdmVycy9tdGQvbmFuZC9uYW5kX2JidC5jCisrKyBs
aW51eC0yLjYuMjguNy9tb2QvZHJpdmVycy9tdGQvbmFuZC9uYW5kX2JidC5jCkBAIC0xMDI3LDEx
ICsxMDI3LDEwIEBACiAJaWYgKCF0aGlzLT5iYnQgfHwgIXRkKQogCQlyZXR1cm4gLUVJTlZBTDsK
IAotCWxlbiA9IG10ZC0+c2l6ZSA+PiAodGhpcy0+YmJ0X2VyYXNlX3NoaWZ0ICsgMik7CiAJLyog
QWxsb2NhdGUgYSB0ZW1wb3JhcnkgYnVmZmVyIGZvciBvbmUgZXJhc2VibG9jayBpbmNsLiBvb2Ig
Ki8KIAlsZW4gPSAoMSA8PCB0aGlzLT5iYnRfZXJhc2Vfc2hpZnQpOwogCWxlbiArPSAobGVuID4+
IHRoaXMtPnBhZ2Vfc2hpZnQpICogbXRkLT5vb2JzaXplOwotCWJ1ZiA9IGttYWxsb2MobGVuLCBH
RlBfS0VSTkVMKTsKKwlidWYgPSB2bWFsbG9jKGxlbik7CiAJaWYgKCFidWYpIHsKIAkJcHJpbnRr
KEtFUk5fRVJSICJuYW5kX3VwZGF0ZV9iYnQ6IE91dCBvZiBtZW1vcnlcbiIpOwogCQlyZXR1cm4g
LUVOT01FTTsKQEAgLTEwNjQsNyArMTA2Myw3IEBACiAJfQogCiAgb3V0OgotCWtmcmVlKGJ1Zik7
CisJdmZyZWUoYnVmKTsKIAlyZXR1cm4gcmVzOwogfQogCg==

------_=_NextPart_001_01C99D10.DD7175B1
Content-Type: application/octet-stream;
	name="README"
Content-Transfer-Encoding: base64
Content-Description: README
Content-Disposition: attachment;
	filename="README"

Rml4ZXMgYW4gb3V0IG9mIG1lbW9yeSBlcnJvciBmb3VuZCB3aGVuIGF0dGVtcHRpbmcgdG8gc3Rv
cmUgdGhlIGJhZCBibG9jayB0YWJsZSBpbiBuYW5kIGZsYXNoIGZvciBjaGlwcyB0aGF0IGhhdmUg
bGFyZ2UgKDEyOEspIGJsb2NrIHNpemVzLiAgR2VuZXJhdGVkIGJ5IFRvbSBCYXN0ZXJhc2ggPHRi
YXN0ZXJhc2hAdHJhbmUuY29tPg==

------_=_NextPart_001_01C99D10.DD7175B1--
