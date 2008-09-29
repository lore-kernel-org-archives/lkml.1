Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYI2NjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYI2NjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYI2NjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:39:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51535 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYI2NjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:39:13 -0400
Message-ID: <48E0DA7C.5010403@canonical.com>
Date: Mon, 29 Sep 2008 09:39:08 -0400
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors bitmap.
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------080506090909060609030508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080506090909060609030508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------080506090909060609030508
Content-Type: application/mbox;
 name="0001-x86-Reserve-FIRST_DEVICE_VECTOR-in-used_vectors-bit.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="0001-x86-Reserve-FIRST_DEVICE_VECTOR-in-used_vectors-bit.pat";
 filename*1="ch"

RnJvbSBhMjcyYTI4ZjUyMGM1OGE4NDg1M2UwOThiNGVlNTY1NDg2Y2E1MDYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gQmFkZXIgPHN0ZWZhbi5iYWRlckBjYW5v
bmljYWwuY29tPgpEYXRlOiBTYXQsIDI3IFNlcCAyMDA4IDExOjA3OjMwIC0wNDAwClN1Ympl
Y3Q6IFtQQVRDSF0geDg2OiBSZXNlcnZlIEZJUlNUX0RFVklDRV9WRUNUT1IgaW4gdXNlZF92
ZWN0b3JzIGJpdG1hcC4KClNvbWVvbmUgZnJvbSB0aGUgY29tbXVuaXR5IGZvdW5kIG91dCwg
dGhhdCBhZnRlciByZXBlYXRlZGx5IHVubG9hZGluZyBhbmQKbG9hZGluZyBhIGRldmljZSBk
cml2ZXIgdGhhdCB1c2VzIE1TSSBJUlFzLCB0aGUgc3lzdGVtIGV2ZW50dWFsbHkgYXNzaWdu
ZWQKdGhlIHZlY3RvciBpbml0aWFsbHkgcmVzZXJ2ZWQgZm9yIElSUTAgdG8gdGhlIGRldmlj
ZSBkcml2ZXIuCgpUaGUgcmVhc29uIGZvciB0aGlzIGlzLCB0aGF0IGFsdGhvdWdoIElSUTAg
aXMgdGllZCB0byB0aGUgRklSU1RfREVWSUNFX1ZFQ1RPUgp3aGVuIGRlY2xhcmluZyB0aGUg
aXJxX3ZlY3RvciB0YWJsZSwgdGhlIGNvcnJlc3BvbmRpbmcgYml0IGluIHRoZSB1c2VkX3Zl
Y3RvcnMKbWFwIGlzIG5vdCBzZXQuIFNvLCBpZiB2ZWN0b3JzIGFyZSByZWxlYXNlZCBhbmQg
YXNzaWduZWQgb2Z0ZW4gZW5vdWdoLCB0aGUKdmVjdG9yIHdpbGwgZ2V0IGFzc2lnbmVkIHRv
IGFub3RoZXIgaW50ZXJydXB0LiBUaGlzIGhhcHBlbnMgbW9yZSBvZnRlbiB3aXRoCk1TSSBp
bnRlcnJ1cHRzIGFzIHRob3NlIGFyZSBleGNsdXNpdmVseSB1c2luZyBhIHZlY3Rvci4KCkZp
eCB0aGlzIGJ5IHNldHRpbmcgdGhlIGJpdCBmb3IgdGhlIEZJUlNUX0RFVklDRV9WRUNUT1Ig
aW4gdGhlIGJpdG1hcC4KClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBCYWRlciA8c3RlZmFuLmJh
ZGVyQGNhbm9uaWNhbC5jb20+Ci0tLQogYXJjaC94ODYva2VybmVsL2lvX2FwaWNfMzIuYyB8
ICAgIDMgKysrCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY18zMi5jIGIvYXJj
aC94ODYva2VybmVsL2lvX2FwaWNfMzIuYwppbmRleCAwOWNkZGI1Li5iZmQ5ZmM1IDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY18zMi5jCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9pb19hcGljXzMyLmMKQEAgLTIzMTQsNiArMjMxNCw5IEBAIHZvaWQgX19pbml0IHNl
dHVwX0lPX0FQSUModm9pZCkKIAlmb3IgKGkgPSBmaXJzdF9zeXN0ZW1fdmVjdG9yOyBpIDwg
TlJfVkVDVE9SUzsgaSsrKQogCQlzZXRfYml0KGksIHVzZWRfdmVjdG9ycyk7CiAKKwkvKiBN
YXJrIEZJUlNUX0RFVklDRV9WRUNUT1Igd2hpY2ggaXMgYXNzaWduZWQgdG8gSVJRMCBhcyB1
c2VkLiAqLworCXNldF9iaXQoRklSU1RfREVWSUNFX1ZFQ1RPUiwgdXNlZF92ZWN0b3JzKTsK
KwogCWVuYWJsZV9JT19BUElDKCk7CiAKIAlpb19hcGljX2lycXMgPSB+UElDX0lSUVM7Ci0t
IAoxLjUuNC4zCgo=
--------------080506090909060609030508--
