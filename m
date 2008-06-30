Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYF3Flc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYF3Flc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 01:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYF3FlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 01:41:22 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:33800 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYF3FlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 01:41:21 -0400
Message-ID: <486871FC.3010300@kernel.org>
Date: Sun, 29 Jun 2008 22:41:16 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
References: <486357EC.5060205@kernel.org> <21854.1214607853@redhat.com>
In-Reply-To: <21854.1214607853@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000003060402010105010805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000003060402010105010805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Howells wrote:
| Andrew G. Morgan <morgan@kernel.org> wrote:
|
|> +static inline int cap_limit_straced_target(void) { return 1; }
|
| Calling it cap_limit_ptraced_target() would probably be better.

You are right. Fix-up patch attached.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIaHH8+bHCR3gb8jsRAgKHAJ4uu7Xd6PZObvIwzvJPSA6lGBpY1QCfUb20
bw1vY5cX8qW7UBMel6qgi5I=
=iacs
-----END PGP SIGNATURE-----

--------------000003060402010105010805
Content-Type: text/plain;
 name="0001-ptraced-straced.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="0001-ptraced-straced.patch"

RnJvbSAwYjNmNDhmNTA5YmY5MzRmOWZkYzgzYTZlODUxYmZkNjljNzc5OTUyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVs
Lm9yZz4KRGF0ZTogU3VuLCAyOSBKdW4gMjAwOCAyMjozNzo0MCAtMDcwMApTdWJqZWN0OiBb
UEFUQ0hdIHB0cmFjZWQgLT4gc3RyYWNlZAoKV2l0aGluIHRoZSBrZXJuZWwsIHB0cmFjZWQg
aXMgYSBtb3JlIGFwcHJvcHJpYXRlIG5hbWUuCgpSZXBvcnRlZC1ieTogRGF2aWQgSG93ZWxs
cyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogQW5kcmV3IEcuIE1vcmdh
biA8bW9yZ2FuQGtlcm5lbC5vcmc+Ci0tLQogc2VjdXJpdHkvY29tbW9uY2FwLmMgfCAgICA2
ICsrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvY29tbW9uY2FwLmMgYi9zZWN1cml0eS9jb21t
b25jYXAuYwppbmRleCBhOWVhOTIxLi4zM2QzNDMzIDEwMDY0NAotLS0gYS9zZWN1cml0eS9j
b21tb25jYXAuYworKysgYi9zZWN1cml0eS9jb21tb25jYXAuYwpAQCAtMTAzLDEzICsxMDMs
MTMgQEAgc3RhdGljIGlubGluZSBpbnQgY2FwX2luaF9pc19jYXBwZWQodm9pZCkKIAlyZXR1
cm4gKGNhcF9jYXBhYmxlKGN1cnJlbnQsIENBUF9TRVRQQ0FQKSAhPSAwKTsKIH0KIAotc3Rh
dGljIGlubGluZSBpbnQgY2FwX2xpbWl0X3N0cmFjZWRfdGFyZ2V0KHZvaWQpIHsgcmV0dXJu
IDE7IH0KK3N0YXRpYyBpbmxpbmUgaW50IGNhcF9saW1pdF9wdHJhY2VkX3RhcmdldCh2b2lk
KSB7IHJldHVybiAxOyB9CiAKICNlbHNlIC8qIGllLiwgbmRlZiBDT05GSUdfU0VDVVJJVFlf
RklMRV9DQVBBQklMSVRJRVMgKi8KIAogc3RhdGljIGlubGluZSBpbnQgY2FwX2Jsb2NrX3Nl
dHBjYXAoc3RydWN0IHRhc2tfc3RydWN0ICp0KSB7IHJldHVybiAwOyB9CiBzdGF0aWMgaW5s
aW5lIGludCBjYXBfaW5oX2lzX2NhcHBlZCh2b2lkKSB7IHJldHVybiAxOyB9Ci1zdGF0aWMg
aW5saW5lIGludCBjYXBfbGltaXRfc3RyYWNlZF90YXJnZXQodm9pZCkKK3N0YXRpYyBpbmxp
bmUgaW50IGNhcF9saW1pdF9wdHJhY2VkX3RhcmdldCh2b2lkKQogewogCXJldHVybiAhY2Fw
YWJsZShDQVBfU0VUUENBUCk7CiB9CkBAIC0zNDgsNyArMzQ4LDcgQEAgdm9pZCBjYXBfYnBy
bV9hcHBseV9jcmVkcyAoc3RydWN0IGxpbnV4X2JpbnBybSAqYnBybSwgaW50IHVuc2FmZSkK
IAkJCQlicHJtLT5lX3VpZCA9IGN1cnJlbnQtPnVpZDsKIAkJCQlicHJtLT5lX2dpZCA9IGN1
cnJlbnQtPmdpZDsKIAkJCX0KLQkJCWlmIChjYXBfbGltaXRfc3RyYWNlZF90YXJnZXQoKSkg
eworCQkJaWYgKGNhcF9saW1pdF9wdHJhY2VkX3RhcmdldCgpKSB7CiAJCQkJbmV3X3Blcm1p
dHRlZCA9CiAJCQkJCWNhcF9pbnRlcnNlY3QobmV3X3Blcm1pdHRlZCwKIAkJCQkJCSAgICAg
IGN1cnJlbnQtPmNhcF9wZXJtaXR0ZWQpOwotLSAKMS41LjYuMQoK
--------------000003060402010105010805--
