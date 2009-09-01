Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZIAVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZIAVcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 17:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZIAVcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 17:32:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37214 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZIAVcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 17:32:52 -0400
Message-ID: <4A9D93D1.2080207@gentoo.org>
Date: Tue, 01 Sep 2009 16:36:17 -0500
From: "Jory A. Pratt" <anarchy@gentoo.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090831 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hardened-dev@gentoo.org
Subject: PATCH] fix-cc-options-test to ensure we do not step on compile flags
X-Enigmail-Version: 0.97a
Content-Type: multipart/mixed;
 boundary="------------080402060000030206040801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080402060000030206040801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

If the tests do not pass the macro of -D__KERNEL__ we overstep compile
flags needed to build a proper kernel. If the check is not correct the
kernel will use -fPIE if gcc specs passes as default options.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqdk9EACgkQwnA7Q1Z0YSefEQCeKZeYx4/jKmoUTHEHMNLTcBs5
T2sAnjEw4wn8/5gLEtxFoiF/kzeAwohC
=yaUy
-----END PGP SIGNATURE-----

--------------080402060000030206040801
Content-Type: text/plain;
 name="fix-cc-options-test.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fix-cc-options-test.patch"

VGhlIGFyY2gvKi9ib290L01ha2VmaWxlIHVzZSBjYy1vcHRpb25zIHRvIGNoZWNrIGZvciBH
Q0MgY29tbWFuZCBvcHRpb25zIGFuZApjYy1vcHRpb25zIHVzZSB0aGUgaGFyZGVuZWQgc3Bl
Y3Mgd2hlbiBjaGVja2luZyBmb3IgR0NDIGNvbW1hbmQgb3B0aW9ucy4KV2hlbiAtZlBJRSBp
cyBwYXNzIHRvIGNjMSBpdCBjYW4ndCB1c2UgLWZmcmVlc3RhbmRpbmcgb3IgLWZuby10b3Bs
ZXZlbC1yZW9yZGVyLgpUaGVuIGl0IGZhaWwgdG8gYnVpbGQgc3R1ZmYgd2l0aCAtZmZyZWVz
dGFuZGluZyBhbmQgLWZuby10b3BsZXZlbC1yZW9yZGVyLgpUaGFua3MgdG8gRnJlZHJpYyBK
b2hhbnNzb24gPGpvaGFuc3Nvbl9mcmVkcmljQGhvdG1haWwuY29tPiBmb3IgZmluZGluZyB0
aGUgbWFpbgpwcm9ibGVtIGJlaGluZCBhIGZhaWxlZCBidWlsZCB1c2luZyBhIGhhcmRlbmVk
IHRvb2xjaGFpbi4KClNpZ25lZC1vZmYtYnk6IE1hZ251cyBHcmFuYmVyZyA8em9ycnlAdW1l
Lm51PgpTaWduZWQtb2ZmLWJ5OiBKb3J5IEEuIFByYXR0IDxhbmFyY2h5QGdlbnRvby5vcmc+
CgpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9LYnVpbGQuaW5jbHVkZSBiL3NjcmlwdHMvS2J1aWxk
LmluY2x1ZGUKaW5kZXggYzI5YmU4Zi4uNDMzMDBiMyAxMDA2NDQKLS0tIGEvc2NyaXB0cy9L
YnVpbGQuaW5jbHVkZQorKysgYi9zY3JpcHRzL0tidWlsZC5pbmNsdWRlCkBAIC0xMDUsMTIg
KzEwNSwxMiBAQCBhcy1pbnN0ciA9ICQoY2FsbCB0cnktcnVuLFwKICMgVXNhZ2U6IGNmbGFn
cy15ICs9ICQoY2FsbCBjYy1vcHRpb24sLW1hcmNoPXdpbmNoaXAtYzYsLW1hcmNoPWk1ODYp
CiAKIGNjLW9wdGlvbiA9ICQoY2FsbCB0cnktcnVuLFwKLQkkKENDKSAkKEtCVUlMRF9DRkxB
R1MpICQoMSkgLWMgLXhjIC9kZXYvbnVsbCAtbyAiJCRUTVAiLCQoMSksJCgyKSkKKwkkKEND
KSAkKEtCVUlMRF9DUFBGTEFHUykgJChLQlVJTERfQ0ZMQUdTKSAkKDEpIC1jIC14YyAvZGV2
L251bGwgLW8gIiQkVE1QIiwkKDEpLCQoMikpCiAKICMgY2Mtb3B0aW9uLXluCiAjIFVzYWdl
OiBmbGFnIDo9ICQoY2FsbCBjYy1vcHRpb24teW4sLW1hcmNoPXdpbmNoaXAtYzYpCiBjYy1v
cHRpb24teW4gPSAkKGNhbGwgdHJ5LXJ1bixcCi0JJChDQykgJChLQlVJTERfQ0ZMQUdTKSAk
KDEpIC1jIC14YyAvZGV2L251bGwgLW8gIiQkVE1QIix5LG4pCisJJChDQykgJChLQlVJTERf
Q1BQRkxBR1MpICQoS0JVSUxEX0NGTEFHUykgJCgxKSAtYyAteGMgL2Rldi9udWxsIC1vICIk
JFRNUCIseSxuKQogCiAjIGNjLW9wdGlvbi1hbGlnbgogIyBQcmVmaXggYWxpZ24gd2l0aCBl
aXRoZXIgLWZhbGlnbiBvciAtbWFsaWduCg==
--------------080402060000030206040801--
