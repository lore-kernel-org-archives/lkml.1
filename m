Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYFZIs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYFZIs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYFZIsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:48:46 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:47548 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbYFZIsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:48:45 -0400
Message-ID: <486357EC.5060205@kernel.org>
Date: Thu, 26 Jun 2008 01:48:44 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] security: filesystem capabilities bugfix2
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060706090906020903070803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060706090906020903070803
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Bugfix for strace, and CAP_SETPCAP, in the case that filesystem
capabilities are supported.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIY1fr+bHCR3gb8jsRAph7AKDOlmeveIpQs1jhIs0TJxjCdMAS5ACgsml6
7UYR+FZpW2XdmG8PkiZzemU=
=+Ko+
-----END PGP SIGNATURE-----

--------------060706090906020903070803
Content-Type: text/plain;
 name="0002-Blunt-CAP_SETPCAP-on-strace-with-filesystem-capabili.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="0002-Blunt-CAP_SETPCAP-on-strace-with-filesystem-capabili.pa";
 filename*1="tch"

RnJvbSBmNDQxOWM3OGZmZjc3YzRmYTNjZGZhNmIwYTc4ZWRhZTkyZGRmNDY3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVs
Lm9yZz4KRGF0ZTogV2VkLCAyNSBKdW4gMjAwOCAyMzoyNDoxMCAtMDcwMApTdWJqZWN0OiBb
UEFUQ0hdIEJsdW50IENBUF9TRVRQQ0FQIG9uIHN0cmFjZSB3aXRoIGZpbGVzeXN0ZW0gY2Fw
YWJpbGl0eSBzdXBwb3J0CgpUaGUgZmlsZXN5c3RlbSBjYXBhYmlsaXR5IHN1cHBvcnQgbWVh
bmluZyBmb3IgQ0FQX1NFVFBDQVAgaXMgbGVzcwpwb3dlcmZ1bCB0aGFuIHRoZSBub24tZmls
ZXN5c3RlbSBjYXBhYmlsaXR5IHN1cHBvcnQuIEFzIHN1Y2gsIHdoZW4KZmlsZXN5c3RlbSBj
YXBhYmlsaXRpZXMgYXJlIGNvbmZpZ3VyZWQsIHdlIHNob3VsZCBub3QgcGVybWl0CkNBUF9T
RVRQQ0FQIHRvICdlbmhhbmNlJyB0aGUgY3VycmVudCBwcm9jZXNzIHRocm91Z2ggc3RyYWNl
Cm1hbmlwdWxhdGlvbiBvZiBhIGNoaWxkIHByb2Nlc3MuCgpTaWduZWQtb2ZmLWJ5OiBBbmRy
ZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVsLm9yZz4KLS0tCiBzZWN1cml0eS9jb21tb25j
YXAuYyB8ICAgMTMgKysrKysrKysrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2NvbW1vbmNh
cC5jIGIvc2VjdXJpdHkvY29tbW9uY2FwLmMKaW5kZXggNWVkYWJjNy4uYTllYTkyMSAxMDA2
NDQKLS0tIGEvc2VjdXJpdHkvY29tbW9uY2FwLmMKKysrIGIvc2VjdXJpdHkvY29tbW9uY2Fw
LmMKQEAgLTEwMywxMCArMTAzLDE2IEBAIHN0YXRpYyBpbmxpbmUgaW50IGNhcF9pbmhfaXNf
Y2FwcGVkKHZvaWQpCiAJcmV0dXJuIChjYXBfY2FwYWJsZShjdXJyZW50LCBDQVBfU0VUUENB
UCkgIT0gMCk7CiB9CiAKK3N0YXRpYyBpbmxpbmUgaW50IGNhcF9saW1pdF9zdHJhY2VkX3Rh
cmdldCh2b2lkKSB7IHJldHVybiAxOyB9CisKICNlbHNlIC8qIGllLiwgbmRlZiBDT05GSUdf
U0VDVVJJVFlfRklMRV9DQVBBQklMSVRJRVMgKi8KIAogc3RhdGljIGlubGluZSBpbnQgY2Fw
X2Jsb2NrX3NldHBjYXAoc3RydWN0IHRhc2tfc3RydWN0ICp0KSB7IHJldHVybiAwOyB9CiBz
dGF0aWMgaW5saW5lIGludCBjYXBfaW5oX2lzX2NhcHBlZCh2b2lkKSB7IHJldHVybiAxOyB9
CitzdGF0aWMgaW5saW5lIGludCBjYXBfbGltaXRfc3RyYWNlZF90YXJnZXQodm9pZCkKK3sK
KwlyZXR1cm4gIWNhcGFibGUoQ0FQX1NFVFBDQVApOworfQogCiAjZW5kaWYgLyogZGVmIENP
TkZJR19TRUNVUklUWV9GSUxFX0NBUEFCSUxJVElFUyAqLwogCkBAIC0zNDIsOSArMzQ4LDEw
IEBAIHZvaWQgY2FwX2Jwcm1fYXBwbHlfY3JlZHMgKHN0cnVjdCBsaW51eF9iaW5wcm0gKmJw
cm0sIGludCB1bnNhZmUpCiAJCQkJYnBybS0+ZV91aWQgPSBjdXJyZW50LT51aWQ7CiAJCQkJ
YnBybS0+ZV9naWQgPSBjdXJyZW50LT5naWQ7CiAJCQl9Ci0JCQlpZiAoIWNhcGFibGUgKENB
UF9TRVRQQ0FQKSkgewotCQkJCW5ld19wZXJtaXR0ZWQgPSBjYXBfaW50ZXJzZWN0IChuZXdf
cGVybWl0dGVkLAotCQkJCQkJCWN1cnJlbnQtPmNhcF9wZXJtaXR0ZWQpOworCQkJaWYgKGNh
cF9saW1pdF9zdHJhY2VkX3RhcmdldCgpKSB7CisJCQkJbmV3X3Blcm1pdHRlZCA9CisJCQkJ
CWNhcF9pbnRlcnNlY3QobmV3X3Blcm1pdHRlZCwKKwkJCQkJCSAgICAgIGN1cnJlbnQtPmNh
cF9wZXJtaXR0ZWQpOwogCQkJfQogCQl9CiAJfQotLSAKMS41LjMuNwoK
--------------060706090906020903070803--
