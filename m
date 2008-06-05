Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYFEPHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYFEPHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYFEPHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:07:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9736 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYFEPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:07:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:content-type;
	b=wP81euH3Jj8okDa4bfvREhoK1aIPCE9WTjz5n7nG7+Azy5Y0iuZA+70gEtAJawQOD
	wSl+trvL5AQuMFvdiTpUw==
Message-ID: <4ca0a85e0806050807v1ad0c309y75badc3fff7b796f@mail.gmail.com>
Date: Thu, 5 Jun 2008 11:07:29 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] pagemap: Make /proc/kpage{count,flags} return EINVAL (not EIO) on unaligned read.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_798_26001927.1212678449278"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_798_26001927.1212678449278
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

If a process tries to read at a position that's not a multiple of 8,
or for a count that's not a multiple of 8, they've passed an invalid
argument to read (for this file), so we should return EINVAL.

------=_Part_798_26001927.1212678449278
Content-Type: text/x-patch;
 name=0004-Make-proc-kpage-count-flags-return-EINVAL-not-EIO.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh3hfk250
Content-Disposition: attachment;
 filename=0004-Make-proc-kpage-count-flags-return-EINVAL-not-EIO.patch

RnJvbSBmMDM3MjlkM2RhM2E3ZTM4ZTNkOGZiYTI4MjZlYTlkZDg4YmFhYWYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgVHV0dGxlIDx0dHV0dGxlQGdvb2dsZS5jb20+CkRh
dGU6IFRodSwgNSBKdW4gMjAwOCAxMDo0OTowMSAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIE1ha2Ug
L3Byb2Mva3BhZ2V7Y291bnQsZmxhZ3N9IHJldHVybiBFSU5WQUwgKG5vdCBFSU8pIG9uIHVuYWxp
Z25lZCByZWFkLgoKVGhpcyBpcyB3aGF0IC9wcm9jL3BpZC9wYWdlbWFwIGRvZXMsIGFuZCBzZWVt
cyB0byBtYWtlIG1vcmUgc2Vuc2UsIGFzIHRoZQplcnJvciBpcyByZWFsbHkgdGhhdCB0aGUgcmVh
ZCBoYWQgYW4gaW52YWxpZCBhcmd1bWVudCAobG9jYXRpb24gb3Igc2l6ZSksCm5vdCB0aGF0IHRo
ZSB1bmRlcmx5aW5nIGRhdGEgY291bGQgbm90IGJlIGFjY2Vzc2VkLgoKU2lnbmVkLW9mZi1ieTog
VGhvbWFzIFR1dHRsZSA8dHR1dHRsZUBnb29nbGUuY29tPgotLS0KIGZzL3Byb2MvcHJvY19taXNj
LmMgfCAgICA0ICsrLS0KIDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3Byb2MvcHJvY19taXNjLmMgYi9mcy9wcm9jL3Byb2Nf
bWlzYy5jCmluZGV4IDVhMTYwOTAuLjdlMjc3ZjIgMTAwNjQ0Ci0tLSBhL2ZzL3Byb2MvcHJvY19t
aXNjLmMKKysrIGIvZnMvcHJvYy9wcm9jX21pc2MuYwpAQCAtNzE2LDcgKzcxNiw3IEBAIHN0YXRp
YyBzc2l6ZV90IGtwYWdlY291bnRfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhciBfX3VzZXIg
KmJ1ZiwKIAlwZm4gPSBzcmMgLyBLUE1TSVpFOwogCWNvdW50ID0gbWluX3Qoc2l6ZV90LCBjb3Vu
dCwgKG1heF9wZm4gKiBLUE1TSVpFKSAtIHNyYyk7CiAJaWYgKHNyYyAmIEtQTU1BU0sgfHwgY291
bnQgJiBLUE1NQVNLKQotCQlyZXR1cm4gLUVJTzsKKwkJcmV0dXJuIC1FSU5WQUw7CiAKIAl3aGls
ZSAoY291bnQgPiAwKSB7CiAJCXBwYWdlID0gTlVMTDsKQEAgLTc4Miw3ICs3ODIsNyBAQCBzdGF0
aWMgc3NpemVfdCBrcGFnZWZsYWdzX3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2Vy
ICpidWYsCiAJcGZuID0gc3JjIC8gS1BNU0laRTsKIAljb3VudCA9IG1pbl90KHVuc2lnbmVkIGxv
bmcsIGNvdW50LCAobWF4X3BmbiAqIEtQTVNJWkUpIC0gc3JjKTsKIAlpZiAoc3JjICYgS1BNTUFT
SyB8fCBjb3VudCAmIEtQTU1BU0spCi0JCXJldHVybiAtRUlPOworCQlyZXR1cm4gLUVJTlZBTDsK
IAogCXdoaWxlIChjb3VudCA+IDApIHsKIAkJcHBhZ2UgPSBOVUxMOwotLSAKMS41LjMuNgoK
------=_Part_798_26001927.1212678449278--
