Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZFVTMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZFVTMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZFVTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:12:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZFVTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:12:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:x-system-of-record;
	b=BC5iMJe/m7A/GBAFdmyRsYhtmWgXI1A/ndHUmS7ZQKGVjHv/mD+gDfZ70JXRv+Msn
	0WrZ/BiFiwr9OKYT4Ch+g==
MIME-Version: 1.0
In-Reply-To: <21c5ff280906221115v302d8b95t4a4ae2df86289056@mail.gmail.com>
References: <21c5ff280906221115v302d8b95t4a4ae2df86289056@mail.gmail.com>
Date: Mon, 22 Jun 2009 15:04:15 -0400
Message-ID: <21c5ff280906221204i72bec97awc7469a3db10f5759@mail.gmail.com>
Subject: Re: [patch] small sendfile fixes
From: Robert Love <rlove@google.com>
To: lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=0016e640c91e50e839046cf48a73
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e640c91e50e839046cf48a73
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

And...the actual patch.

      Robert

--0016e640c91e50e839046cf48a73
Content-Type: application/octet-stream; 
	name="sendfile-fix-2.6.30-rlove-1.patch"
Content-Disposition: attachment; 
	filename="sendfile-fix-2.6.30-rlove-1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw9k3fmh0

RnJvbSBlNTg4Yjc1NzQ1YTUyNGU0MWFjYTcyNTgwYTkxNzNkMDYwN2M4YmEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2JlcnQgTG92ZSA8cmxvdmVAZGhjcC0xNzItMzEtMjA1LTIz
Ni5jYW0uY29ycC5nb29nbGUuY29tPgpEYXRlOiBUaHUsIDE4IEp1biAyMDA5IDE0OjQyOjExIC0w
NDAwClN1YmplY3Q6IFtQQVRDSF0gdGhyZWUgZml4ZXMgZm9yIHNlbmRmaWxlCgpUaHJlZSBmaXhl
cyBmb3Igc2VuZGZpbGUsIG1vc3RseSByZWxhdGVkIHRvIHNlbmRpbmcgbGFyZ2UgZmlsZXMgZnJv
bSBwc2V1ZG8KZmlsZXN5c3RlbXM6CgotIEZpeCBzZW5kZmlsZSBmb3Igb2Zmc2V0cyA+IDMwMEcu
IFRoaXMgY2FuIGhhcHBlbiB3aXRoIHBzZXVkbyBmaWxlc3lzdGVtcy4KICBUaGlzIGhhcHBlbnMg
YmVjYXVzZSB0aGUgb3ZlcmZsb3cgY2hlY2sgaXMgdXNpbmcgaW5vZGUtPmlfc2ItPnNfbWF4Ynl0
ZXMKICBhbmQgbm90IHRoZSBzdXBlcmJsb2NrIG9mIHRoZSBiYWNraW5nIGRldmljZSdzIHNfbWF4
Ynl0ZXMuIEZvciBhIHJlZ3VsYXIgZmlsZQogIHRoZXNlIGFyZSBpbnRlcmNoYW5naWJsZSBidXQg
Zm9yIGEgc3BlY2lhbCBmaWxlIHRoZXNlIGFyZSBkaWZmZXJlbnQgYW5kIHlvdQogIHdhbnQgdGhl
IGxhdHRlci4KCi0gRG9uJ3QgY29tcGFyZSBhZ2FpbnN0IHRoZSBtYXggb2YgdGhlIG91dF9pbm9k
ZSdzIHN1cGVyYmxvY2suIERvZXNuJ3QgbWFrZQogIHNlbnNlLgoKLSBGb3IgcHNldWRvIGFuZCBv
dGhlciBmaWxlc3lzdGVtcyB3aXRoIHNfbWF4Ynl0ZXMgc2V0IHRvIH4wVUxMLCBtYXggZW5kcyB1
cAogIGhvbGRpbmcgYSBuZWdhdGl2ZSBudW1iZXIgYXMgaXQgaXMgc2lnbmVkLiBDaGVjayBmb3Ig
YW5kIGNvcnJlY3QgdGhhdC4KClBhdGNoIGlzIGFnYWluc3QgMi42LjMwLgoKCVJvYmVydAoKRnJv
bTogTWFuZGVlcCBTaW5naCBCYWluZXMgPG1zYkBnb29nbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBS
b2JlcnQgTG92ZSA8cmxvdmVAZ29vZ2xlLmNvbT4KCi0tLQogZnMvcmVhZF93cml0ZS5jIHwgICAx
MSArKysrKysrKystLQogMSBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcmVhZF93cml0ZS5jIGIvZnMvcmVhZF93cml0ZS5jCmlu
ZGV4IDZjOGM1NWQuLmI1ODY3NjMgMTAwNjQ0Ci0tLSBhL2ZzL3JlYWRfd3JpdGUuYworKysgYi9m
cy9yZWFkX3dyaXRlLmMKQEAgLTgzNSw4ICs4MzUsMTUgQEAgc3RhdGljIHNzaXplX3QgZG9fc2Vu
ZGZpbGUoaW50IG91dF9mZCwgaW50IGluX2ZkLCBsb2ZmX3QgKnBwb3MsCiAJCWdvdG8gZnB1dF9v
dXQ7CiAJY291bnQgPSByZXR2YWw7CiAKLQlpZiAoIW1heCkKLQkJbWF4ID0gbWluKGluX2lub2Rl
LT5pX3NiLT5zX21heGJ5dGVzLCBvdXRfaW5vZGUtPmlfc2ItPnNfbWF4Ynl0ZXMpOworCWlmICgh
bWF4KSB7CisJCW1heCA9IGluX2lub2RlLT5pX21hcHBpbmctPmhvc3QtPmlfc2ItPnNfbWF4Ynl0
ZXM7CisJCS8qCisJCSAqIEZvciBwc3VlZG8gZmlsZXN5c3RlbXMsIHNfbWF4Ynl0ZXMgaXMgfjBV
TEwuIFdoZW4gY29udmVydGVkCisJCSAqIHRvIGxvZmZfdCwgaXQgY2FuIGdvIG5lZ2F0aXZlLiBT
byB3ZSBjaGVjayBmb3IgYW5kIGZpeCB0aGF0LgorCQkgKi8KKwkJaWYgKG1heCA8IDApCisJCQlt
YXggPSBMTE9OR19NQVg7CisJfQogCiAJcG9zID0gKnBwb3M7CiAJcmV0dmFsID0gLUVJTlZBTDsK
LS0gCjEuNi4yLjIKCg==
--0016e640c91e50e839046cf48a73--
