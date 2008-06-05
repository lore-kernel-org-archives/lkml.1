Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYFEPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYFEPGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYFEPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:06:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYFEPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:06:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:content-type;
	b=Bu5B5jdFx9/U/avG+f43ybIZmR++UZOuXKB3J4jTO1dSR95JdTPpJZEUQwzKLILAa
	DDNjsQ/vCkfw05AxRPdug==
Message-ID: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
Date: Thu, 5 Jun 2008 11:06:02 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] pagemap: Make pagemap_read enforce reading in multiples of 8
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_791_16639639.1212678362473"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_791_16639639.1212678362473
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Since kpagecount and kpageflags require reads in multiples of 8, and
it simplifies add_to_pagemap significantly, I added the same
requirement to /proc/pid/pagemap.

------=_Part_791_16639639.1212678362473
Content-Type: text/x-patch;
 name=0003-Make-pagemap_read-enforce-reading-in-multiples-of-8.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh3hdp6l0
Content-Disposition: attachment;
 filename=0003-Make-pagemap_read-enforce-reading-in-multiples-of-8.patch

RnJvbSAyNTkwODczMWI2NzA2OWQ2Y2Y1NmQ4YWY1MjJiNTU0NzllYTc1NzM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgVHV0dGxlIDx0dHV0dGxlQGdvb2dsZS5jb20+CkRh
dGU6IFRodSwgNSBKdW4gMjAwOCAxMDo0NTo1NSAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIE1ha2Ug
cGFnZW1hcF9yZWFkIGVuZm9yY2UgcmVhZGluZyBpbiBtdWx0aXBsZXMgb2YgOC4KClByZXZpb3Vz
bHksIC9wcm9jL3BpZC9wYWdlbWFwIHdvdWxkIGFsbG93IHJlYWRzIG9mIGxlbmd0aHMgdGhhdCB3
ZXJlIG5vdAptdWx0aXBsZXMgb2YgOCB0byBzdWNjZWVkIChhbmQgd291bGQgcmV0dXJuIGNvcnJl
Y3QgZGF0YSksIGJ1dCBoYWQgbm8gd2F5Cm9mIHJlYWRpbmcgdGhlIHJlbWFpbmRlciBvZiB0aGUg
cGFydGlhbCB2YWx1ZSByZXR1cm5lZC4KCi9wcm9jL2twYWdle2NvdW50LGZsYWdzfSBhcmUgYWxz
byBhcnJheXMgb2YgdTY0cywgYW5kIHRoZXkgcmVxdWlyZSB0aGF0CnJlYWRzIGFyZSBhIG11bHRp
cGxlIG9mIDguICBUaGlzIHBhdGNoIG1ha2VzIC9wcm9jL3BpZC9wYWdlbWFwIGNvbnNpc3RlbnQu
CgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgVHV0dGxlIDx0dHV0dGxlQGdvb2dsZS5jb20+Ci0tLQog
ZnMvcHJvYy90YXNrX21tdS5jIHwgICAxOCArKysrLS0tLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9w
cm9jL3Rhc2tfbW11LmMgYi9mcy9wcm9jL3Rhc2tfbW11LmMKaW5kZXggOTkxNTIwMi4uM2Y2ZDY4
MCAxMDA2NDQKLS0tIGEvZnMvcHJvYy90YXNrX21tdS5jCisrKyBiL2ZzL3Byb2MvdGFza19tbXUu
YwpAQCAtNTE5LDIxICs1MTksMTEgQEAgc3RydWN0IHBhZ2VtYXByZWFkIHsKIHN0YXRpYyBpbnQg
YWRkX3RvX3BhZ2VtYXAodW5zaWduZWQgbG9uZyBhZGRyLCB1NjQgcGZuLAogCQkJICBzdHJ1Y3Qg
cGFnZW1hcHJlYWQgKnBtKQogewotCS8qCi0JICogTWFrZSBzdXJlIHRoZXJlJ3Mgcm9vbSBpbiB0
aGUgYnVmZmVyIGZvciBhbgotCSAqIGVudGlyZSBlbnRyeS4gIE90aGVyd2lzZSwgb25seSBjb3B5
IHBhcnQgb2YKLQkgKiB0aGUgcGZuLgotCSAqLwotCWlmIChwbS0+b3V0ICsgUE1fRU5UUllfQllU
RVMgPj0gcG0tPmVuZCkgewotCQlpZiAoY29weV90b191c2VyKHBtLT5vdXQsICZwZm4sIHBtLT5l
bmQgLSBwbS0+b3V0KSkKLQkJCXJldHVybiAtRUZBVUxUOwotCQlwbS0+b3V0ID0gcG0tPmVuZDsK
LQkJcmV0dXJuIFBNX0VORF9PRl9CVUZGRVI7Ci0JfQotCiAJaWYgKGNvcHlfdG9fdXNlcihwbS0+
b3V0LCAmcGZuLCBQTV9FTlRSWV9CWVRFUykpCiAJCXJldHVybiAtRUZBVUxUOwogCXBtLT5vdXQg
Kz0gUE1fRU5UUllfQllURVM7CisJaWYgKHBtLT5vdXQgPj0gcG0tPmVuZCkKKwkJcmV0dXJuIFBN
X0VORF9PRl9CVUZGRVI7CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTYzMyw4ICs2MjMsOCBAQCBzdGF0
aWMgc3NpemVfdCBwYWdlbWFwX3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICpi
dWYsCiAJCWdvdG8gb3V0X3Rhc2s7CiAKIAlyZXQgPSAtRUlOVkFMOwotCS8qIGZpbGUgcG9zaXRp
b24gbXVzdCBiZSBhbGlnbmVkICovCi0JaWYgKCpwcG9zICUgUE1fRU5UUllfQllURVMpCisJLyog
ZmlsZSBwb3NpdGlvbiBhbmQgY291bnQgbXVzdCBiZSBhbGlnbmVkICovCisJaWYgKCgqcHBvcyAl
IFBNX0VOVFJZX0JZVEVTKSB8fCAoY291bnQgJSBQTV9FTlRSWV9CWVRFUykpCiAJCWdvdG8gb3V0
X3Rhc2s7CiAKIAlyZXQgPSAwOwotLSAKMS41LjMuNgoK
------=_Part_791_16639639.1212678362473--
