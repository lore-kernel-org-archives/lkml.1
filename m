Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYLEKVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYLEKVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYLEKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:51 -0500
Received: from vps1.tull.net ([66.180.172.116]:47090 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751795AbYLEKUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:50 -0500
Mail-From: nobody Fri Dec  5 14:07:57 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in c-checksum.c
To: Harvey Harrison <harvey.harrison@gmail.com>,
       Nick Andrew <nick@nick-andrew.net>, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:07:57 +1100
Message-ID: <20081205030757.31846.86233.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in c-checksum.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 arch/sh/lib64/c-checksum.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/sh/lib64/c-checksum.c b/arch/sh/lib64/c-checksum.c
index 5c284e0..73c0877 100644
--- a/arch/sh/lib64/c-checksum.c
+++ b/arch/sh/lib64/c-checksum.c
@@ -35,7 +35,7 @@ static inline unsigned short foldto16(unsigned long x)
 
 static inline unsigned short myfoldto16(unsigned long long x)
 {
-	/* Fold down to 32-bits so we don't loose in the typedef-less
+	/* Fold down to 32-bits so we don't lose in the typedef-less
 	   network stack.  */
 	/* 64 to 33 */
 	x = (x & 0xffffffff) + (x >> 32);
@@ -199,7 +199,7 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 	result = (__force u64) saddr + (__force u64) daddr +
 		 (__force u64) sum + ((len + proto) << 8);
 
-	/* Fold down to 32-bits so we don't loose in the typedef-less
+	/* Fold down to 32-bits so we don't lose in the typedef-less
 	   network stack.  */
 	/* 64 to 33 */
 	result = (result & 0xffffffff) + (result >> 32);


