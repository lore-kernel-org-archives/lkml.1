Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbYCAWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbYCAWct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 17:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYCAWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 17:32:40 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:42545 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbYCAWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 17:32:40 -0500
Message-ID: <47C9D986.3040805@kernel.org>
Date: Sat, 01 Mar 2008 14:32:38 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] cleanup: correct tabbing of check_kill_permission()
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------070000020009010509080909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070000020009010509080909
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew

Here is a small patch to reformat the check_kill_permission() function.
It doesn't change any functionality.

There was something confusing about its tabbing previously, and it also
ran over the 80 column limit.

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHydmF+bHCR3gb8jsRAmehAKDVnrOMVkHPhZslnhE1tVVXl2x07gCgsAse
LdjzfIwC+dmOqfDGLwnhaOo=
=pQEM
-----END PGP SIGNATURE-----

--------------070000020009010509080909
Content-Type: text/plain;
 name="0001-Reformat-check_kill_permission-function-to-make-it.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="0001-Reformat-check_kill_permission-function-to-make-it.patc";
 filename*1="h"

RnJvbSA3ZGRhMGE3YWRiN2FiODcwZTAxZjkzYjZiMDY2NTk4NjY1ZTE1ZjdkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVs
Lm9yZz4KRGF0ZTogTW9uLCAyNSBGZWIgMjAwOCAyMTo0OToyMiAtMDgwMApTdWJqZWN0OiBb
UEFUQ0hdIFJlZm9ybWF0IGNoZWNrX2tpbGxfcGVybWlzc2lvbigpIGZ1bmN0aW9uIHRvIG1h
a2UgaXQgcmVhZGFibGUuCgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3Jn
YW5Aa2VybmVsLm9yZz4KLS0tCiBrZXJuZWwvc2lnbmFsLmMgfCAgIDEyICsrKysrKystLS0t
LQogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEva2VybmVsL3NpZ25hbC5jIGIva2VybmVsL3NpZ25hbC5jCmluZGV4IDg0
OTE3ZmUuLjc3ZjA0MzkgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zaWduYWwuYworKysgYi9rZXJu
ZWwvc2lnbmFsLmMKQEAgLTUzMCwxNyArNTMwLDE5IEBAIHN0YXRpYyBpbnQgY2hlY2tfa2ls
bF9wZXJtaXNzaW9uKGludCBzaWcsIHN0cnVjdCBzaWdpbmZvICppbmZvLAogCWlmICghdmFs
aWRfc2lnbmFsKHNpZykpCiAJCXJldHVybiBlcnJvcjsKIAotCWlmIChpbmZvID09IFNFTkRf
U0lHX05PSU5GTyB8fCAoIWlzX3NpX3NwZWNpYWwoaW5mbykgJiYgU0lfRlJPTVVTRVIoaW5m
bykpKSB7Ci0JCWVycm9yID0gYXVkaXRfc2lnbmFsX2luZm8oc2lnLCB0KTsgLyogTGV0IGF1
ZGl0IHN5c3RlbSBzZWUgdGhlIHNpZ25hbCAqLworCWlmIChpbmZvID09IFNFTkRfU0lHX05P
SU5GTworCSAgICB8fCAoIWlzX3NpX3NwZWNpYWwoaW5mbykgJiYgU0lfRlJPTVVTRVIoaW5m
bykpKSB7CisJCSAvKiBMZXQgYXVkaXQgc3lzdGVtIHNlZSB0aGUgc2lnbmFsICovCisJCWVy
cm9yID0gYXVkaXRfc2lnbmFsX2luZm8oc2lnLCB0KTsKIAkJaWYgKGVycm9yKQogCQkJcmV0
dXJuIGVycm9yOwogCQllcnJvciA9IC1FUEVSTTsKLQkJaWYgKCgoc2lnICE9IFNJR0NPTlQp
IHx8Ci0JCQkodGFza19zZXNzaW9uX25yKGN1cnJlbnQpICE9IHRhc2tfc2Vzc2lvbl9ucih0
KSkpCisJCWlmICgoKHNpZyAhPSBTSUdDT05UKQorCQkgICAgIHx8ICh0YXNrX3Nlc3Npb25f
bnIoY3VycmVudCkgIT0gdGFza19zZXNzaW9uX25yKHQpKSkKIAkJICAgICYmIChjdXJyZW50
LT5ldWlkIF4gdC0+c3VpZCkgJiYgKGN1cnJlbnQtPmV1aWQgXiB0LT51aWQpCiAJCSAgICAm
JiAoY3VycmVudC0+dWlkIF4gdC0+c3VpZCkgJiYgKGN1cnJlbnQtPnVpZCBeIHQtPnVpZCkK
IAkJICAgICYmICFjYXBhYmxlKENBUF9LSUxMKSkKLQkJcmV0dXJuIGVycm9yOworCQkJcmV0
dXJuIGVycm9yOwogCX0KIAogCXJldHVybiBzZWN1cml0eV90YXNrX2tpbGwodCwgaW5mbywg
c2lnLCAwKTsKLS0gCjEuNS4zLjcKCg==
--------------070000020009010509080909--
