Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYCMXwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYCMXwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYCMXw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:52:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:6474 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYCMXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=euxb4SFdiYsK6Zwlb4i4ZTTNJzw+4jm5GhMSWq437hIZ4onI7lw3Wgmn9qCBuG59hfLUH9B5D2uAB9SpyutIVjzYy4VlDzVFTmj7bBh5m9M1EEwgj3TFyYQO73ylTnsheF0UWffx+eNzzM4iejAy9JoKrQBmMJ6KTTiKKTleIE4=
Message-ID: <86802c440803131652sb30c17fu4be905423ba5d9f9@mail.gmail.com>
Date: Thu, 13 Mar 2008 16:52:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: make reserve_bootmem_generic to use new reserve_bootmem
Cc: "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13156_26480738.1205452345802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13156_26480738.1205452345802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_13156_26480738.1205452345802
Content-Type: text/x-patch; name=numa_64_use_new_reserve_bootmem.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdrz5orj1
Content-Disposition: attachment;
 filename=numa_64_use_new_reserve_bootmem.patch

W1BBVENIXSB4ODZfNjQ6IG1ha2UgcmVzZXJ2ZV9ib290bWVtX2dlbmVyaWMgdG8gdXNlIG5ldyBy
ZXNlcnZlX2Jvb3RtZW0KCglbUEFUQ0hdIG1tOiBtYWtlIHJlc2VydmVfYm9vdG1lbSBjYW4gY3Jv
c3NlZCB0aGUgbm9kZXMKCnByb3ZpZGVzIG5ldyByZXNldmVyX2Jvb3RtZW0sIGxldCByZXNlcnZl
X2Jvb3RtZW1fZ2VuZXJpYyB1c2UgdGhhdC4KCmFjY3R1YWx5IHJlc2VydmVfYm9vdG1lX2dlbmVy
aWMgaXMgdXNlZCB0byByZXNlcnZlIGluaXRyYW1kaXNrLgpzbyB3ZSBjYW4gbWFrZSBzdXJlIGV2
ZW4gYm9vdGxvYWRlciBvciBrZXhlYyBsb2FkIHRoYXQgY3Jvc3MgdGhlIG5vZGVzLCByZXNlcnZl
X2Jvb3RtZW0Kc3RpbGwgd29ya3MuCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtl
cm5lbEBnbWFpbC5jb20+CgoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0XzY0LmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdF82NC5jCisrKyBs
aW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdF82NC5jCkBAIC02ODgsNyArNjg4LDcgQEAgdm9pZCBm
cmVlX2luaXRyZF9tZW0odW5zaWduZWQgbG9uZyBzdGFydAogdm9pZCBfX2luaXQgcmVzZXJ2ZV9i
b290bWVtX2dlbmVyaWModW5zaWduZWQgbG9uZyBwaHlzLCB1bnNpZ25lZCBsZW4pCiB7CiAjaWZk
ZWYgQ09ORklHX05VTUEKLQlpbnQgbmlkID0gcGh5c190b19uaWQocGh5cyk7CisJaW50IG5pZCwg
bmV4dF9uaWQ7CiAjZW5kaWYKIAl1bnNpZ25lZCBsb25nIHBmbiA9IHBoeXMgPj4gUEFHRV9TSElG
VDsKIApAQCAtNzA3LDEwICs3MDcsMTQgQEAgdm9pZCBfX2luaXQgcmVzZXJ2ZV9ib290bWVtX2dl
bmVyaWModW5zaQogCiAJLyogU2hvdWxkIGNoZWNrIGhlcmUgYWdhaW5zdCB0aGUgZTgyMCBtYXAg
dG8gYXZvaWQgZG91YmxlIGZyZWUgKi8KICNpZmRlZiBDT05GSUdfTlVNQQorCW5pZCA9IHBoeXNf
dG9fbmlkKHBoeXMpOworCW5leHRfbmlkID0gcGh5c190b19uaWQocGh5cyArIGxlbiAtIDEpOwor
CWlmIChuaWQgPT0gbmV4dF9uaWQpCiAJcmVzZXJ2ZV9ib290bWVtX25vZGUoTk9ERV9EQVRBKG5p
ZCksIHBoeXMsIGxlbiwgQk9PVE1FTV9ERUZBVUxUKTsKLSNlbHNlCi0JcmVzZXJ2ZV9ib290bWVt
KHBoeXMsIGxlbiwgQk9PVE1FTV9ERUZBVUxUKTsKKwllbHNlCiAjZW5kaWYKKwlyZXNlcnZlX2Jv
b3RtZW0ocGh5cywgbGVuLCBCT09UTUVNX0RFRkFVTFQpOworCiAJaWYgKHBoeXMrbGVuIDw9IE1B
WF9ETUFfUEZOKlBBR0VfU0laRSkgewogCQlkbWFfcmVzZXJ2ZSArPSBsZW4gLyBQQUdFX1NJWkU7
CiAJCXNldF9kbWFfcmVzZXJ2ZShkbWFfcmVzZXJ2ZSk7Cg==
------=_Part_13156_26480738.1205452345802--
