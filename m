Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXGQHvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXGQHvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbXGQHtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50995 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbXGQHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing exports of csum_...
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net
Message-Id: <E1IAhoN-0001is-SN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/lib/checksum.c  |    1 +
 arch/ia64/lib/checksum.c   |    1 +
 arch/m68k/lib/checksum.c   |    1 +
 arch/sh64/lib/c-checksum.c |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/lib/checksum.c b/arch/alpha/lib/checksum.c
index ab3761c..8698e07 100644
--- a/arch/alpha/lib/checksum.c
+++ b/arch/alpha/lib/checksum.c
@@ -69,6 +69,7 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 	result = (result & 0xffffffff) + (result >> 32);
 	return (__force __wsum)result;
 }
+EXPORT_SYMBOL(csum_tcpudp_nofold);
 
 /*
  * Do a 64-bit checksum on an arbitrary memory area..
diff --git a/arch/ia64/lib/checksum.c b/arch/ia64/lib/checksum.c
index 4411d9b..9fc9550 100644
--- a/arch/ia64/lib/checksum.c
+++ b/arch/ia64/lib/checksum.c
@@ -60,6 +60,7 @@ csum_tcpudp_nofold (__be32 saddr, __be32 daddr, unsigned short len,
 	result = (result & 0xffffffff) + (result >> 32);
 	return (__force __wsum)result;
 }
+EXPORT_SYMBOL(csum_tcpudp_nofold);
 
 extern unsigned long do_csum (const unsigned char *, long);
 
diff --git a/arch/m68k/lib/checksum.c b/arch/m68k/lib/checksum.c
index cf6bb51..6216f12 100644
--- a/arch/m68k/lib/checksum.c
+++ b/arch/m68k/lib/checksum.c
@@ -422,3 +422,4 @@ csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
 	    );
     return(sum);
 }
+EXPORT_SYMBOL(csum_partial_copy_nocheck);
diff --git a/arch/sh64/lib/c-checksum.c b/arch/sh64/lib/c-checksum.c
index 4b26763..bd55017 100644
--- a/arch/sh64/lib/c-checksum.c
+++ b/arch/sh64/lib/c-checksum.c
@@ -213,3 +213,4 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 
 	return (__wsum)result;
 }
+EXPORT_SYMBOL(csum_tcpudp_nofold);
-- 
1.5.3.GIT


