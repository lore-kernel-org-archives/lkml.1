Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0BNGFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:05:53 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:47141 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0BNGFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=ioLuGcWpxOU/ppxdjNhuJE8OtINB67SMc3WSkj4bSC4tnYiU0720P+VYTm5wmmJhu5
         SCo6wSDVUqU3LALOuwRzkgRlFaGTcPOt4Bk+5Cf6NfVld0pW2A/uVUHjH9NxPvAl+gUf
         vIzZwo7Gl5iQMkzKKjYEpfxev9VjXYG3ZBMlc=
Message-ID: <4B7792BC.8090704@gmail.com>
Date: Sun, 14 Feb 2010 01:05:48 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH v3 1/7] net: tcp_header_len_th and tcp_option_len_th
References: <4B7791CF.9030201@gmail.com>
In-Reply-To: <4B7791CF.9030201@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070504050409080809060001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070504050409080809060001
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Redefine two TCP header functions to accept TCP header pointer.
When subtracting, return signed int to allow error checking.

These functions will be used in subsequent patches that implement
additional features.

Signed-off-by: William.Allen.Simpson@gmail.com
---
  include/linux/tcp.h |   12 ++++++++++++
  1 files changed, 12 insertions(+), 0 deletions(-)

--------------070504050409080809060001
Content-Type: text/plain; x-mac-type="54455854"; x-mac-creator="0";
 name="len_th+2a3+2.6.33-rc8.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="len_th+2a3+2.6.33-rc8.patch"

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdGNwLmggYi9pbmNsdWRlL2xpbnV4L3RjcC5o
CmluZGV4IDdmZWU4YTQuLmQwMTMzY2YgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvdGNw
LmgKKysrIGIvaW5jbHVkZS9saW51eC90Y3AuaApAQCAtMjIzLDYgKzIyMywxOCBAQCBzdGF0
aWMgaW5saW5lIHVuc2lnbmVkIGludCB0Y3Bfb3B0bGVuKGNvbnN0IHN0cnVjdCBza19idWZm
ICpza2IpCiAJcmV0dXJuICh0Y3BfaGRyKHNrYiktPmRvZmYgLSA1KSAqIDQ7CiB9CiAKKy8q
IExlbmd0aCBvZiBmaXhlZCBoZWFkZXIgcGx1cyBzdGFuZGFyZCBvcHRpb25zLiAqLworc3Rh
dGljIGlubGluZSB1bnNpZ25lZCBpbnQgdGNwX2hlYWRlcl9sZW5fdGgoY29uc3Qgc3RydWN0
IHRjcGhkciAqdGgpCit7CisJcmV0dXJuIHRoLT5kb2ZmICogNDsKK30KKworLyogTGVuZ3Ro
IG9mIHN0YW5kYXJkIG9wdGlvbnMgb25seS4gIFRoaXMgY291bGQgYmUgbmVnYXRpdmUuICov
CitzdGF0aWMgaW5saW5lIGludCB0Y3Bfb3B0aW9uX2xlbl90aChjb25zdCBzdHJ1Y3QgdGNw
aGRyICp0aCkKK3sKKwlyZXR1cm4gKGludCkodGgtPmRvZmYgKiA0KSAtIHNpemVvZigqdGgp
OworfQorCiAvKiBUaGlzIGRlZmluZXMgYSBzZWxlY3RpdmUgYWNrbm93bGVkZ2VtZW50IGJs
b2NrLiAqLwogc3RydWN0IHRjcF9zYWNrX2Jsb2NrX3dpcmUgewogCV9fYmUzMglzdGFydF9z
ZXE7Ci0tIAoxLjYuMy4zCgo=
--------------070504050409080809060001--
