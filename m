Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYFZIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYFZIur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYFZIuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:50:23 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:37943 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYFZIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:50:21 -0400
Message-ID: <4863584A.9030301@kernel.org>
Date: Thu, 26 Jun 2008 01:50:18 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] security: filesystem capabilities no longer experimental
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------020908010803020300010604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020908010803020300010604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It is time to drop the experimental tag.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIY1hK+bHCR3gb8jsRAnl4AKDBkfuW/XfiCIPcoVX3FIT6Ctl0cACbBfH4
pGbRuQD7OLrALAk4WLr/rB8=
=GZsK
-----END PGP SIGNATURE-----

--------------020908010803020300010604
Content-Type: text/plain;
 name="0004-Filesystem-capabilities-have-come-of-age.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="0004-Filesystem-capabilities-have-come-of-age.patch"

RnJvbSA0ZWVmYThlNjcwYzRmYTRjMWM0NDU0MzAyZjU4NWVlZjlmNDZiNzRiIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVs
Lm9yZz4KRGF0ZTogV2VkLCAyNSBKdW4gMjAwOCAyMzozMzoxMSAtMDcwMApTdWJqZWN0OiBb
UEFUQ0hdIEZpbGVzeXN0ZW0gY2FwYWJpbGl0aWVzIGhhdmUgY29tZSBvZiBhZ2UuCgpSZW1v
dmUgdGhlIGV4cGVyaW1lbnRhbCB0YWcgZm9yIGNvbmZpZ3VyaW5nIGZpbGVzeXN0ZW0gY2Fw
YWJpbGl0aWVzLgoKU2lnbmVkLW9mZi1ieTogQW5kcmV3IEcuIE1vcmdhbiA8bW9yZ2FuQGtl
cm5lbC5vcmc+Ci0tLQogc2VjdXJpdHkvS2NvbmZpZyB8ICAgIDQgKystLQogMSBmaWxlcyBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
c2VjdXJpdHkvS2NvbmZpZyBiL3NlY3VyaXR5L0tjb25maWcKaW5kZXggNDliNTFmOS4uOWQ1
YjgwNiAxMDA2NDQKLS0tIGEvc2VjdXJpdHkvS2NvbmZpZworKysgYi9zZWN1cml0eS9LY29u
ZmlnCkBAIC04Miw4ICs4Miw4IEBAIGNvbmZpZyBTRUNVUklUWV9DQVBBQklMSVRJRVMKIAkg
IElmIHlvdSBhcmUgdW5zdXJlIGhvdyB0byBhbnN3ZXIgdGhpcyBxdWVzdGlvbiwgYW5zd2Vy
IFkuCiAKIGNvbmZpZyBTRUNVUklUWV9GSUxFX0NBUEFCSUxJVElFUwotCWJvb2wgIkZpbGUg
UE9TSVggQ2FwYWJpbGl0aWVzIChFWFBFUklNRU5UQUwpIgotCWRlcGVuZHMgb24gKFNFQ1VS
SVRZPW4gfHwgU0VDVVJJVFlfQ0FQQUJJTElUSUVTIT1uKSAmJiBFWFBFUklNRU5UQUwKKwli
b29sICJGaWxlIFBPU0lYIENhcGFiaWxpdGllcyIKKwlkZXBlbmRzIG9uIFNFQ1VSSVRZPW4g
fHwgU0VDVVJJVFlfQ0FQQUJJTElUSUVTIT1uCiAJZGVmYXVsdCBuCiAJaGVscAogCSAgVGhp
cyBlbmFibGVzIGZpbGVzeXN0ZW0gY2FwYWJpbGl0aWVzLCBhbGxvd2luZyB5b3UgdG8gZ2l2
ZQotLSAKMS41LjMuNwoK
--------------020908010803020300010604--
