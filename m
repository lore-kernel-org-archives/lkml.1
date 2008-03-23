Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbYCWI3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbYCWI3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758889AbYCWIJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:39 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2283 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759470AbYCWIJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:37 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 099/148] include/asm-x86/posix_types_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:14 -0700
Message-Id: <1206259443-13210-100-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/posix_types_64.h |   54 +++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/asm-x86/posix_types_64.h b/include/asm-x86/posix_types_64.h
index 9926aa4..93e8467 100644
--- a/include/asm-x86/posix_types_64.h
+++ b/include/asm-x86/posix_types_64.h
@@ -46,7 +46,7 @@ typedef unsigned long	__kernel_old_dev_t;
 #ifdef __KERNEL__
 
 #undef __FD_SET
-static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
+<static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
 {
 	unsigned long _tmp = fd / __NFDBITS;
 	unsigned long _rem = fd % __NFDBITS;
@@ -54,7 +54,7 @@ static __inline__ void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
 }
 
 #undef __FD_CLR
-static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
+static inline void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
 {
 	unsigned long _tmp = fd / __NFDBITS;
 	unsigned long _rem = fd % __NFDBITS;
@@ -62,7 +62,7 @@ static __inline__ void __FD_CLR(unsigned long fd, __kernel_fd_set *fdsetp)
 }
 
 #undef __FD_ISSET
-static __inline__ int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
+static inline int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
 {
 	unsigned long _tmp = fd / __NFDBITS;
 	unsigned long _rem = fd % __NFDBITS;
@@ -74,36 +74,36 @@ static __inline__ int __FD_ISSET(unsigned long fd, __const__ __kernel_fd_set *p)
  * for 256 and 1024-bit fd_sets respectively)
  */
 #undef __FD_ZERO
-static __inline__ void __FD_ZERO(__kernel_fd_set *p)
+static inline void __FD_ZERO(__kernel_fd_set *p)
 {
 	unsigned long *tmp = p->fds_bits;
 	int i;
 
 	if (__builtin_constant_p(__FDSET_LONGS)) {
 		switch (__FDSET_LONGS) {
-			case 32:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			  tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			  tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
-			  tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
-			  tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
-			  tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
-			  return;
-			case 16:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
-			  tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
-			  return;
-			case 8:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
-			  return;
-			case 4:
-			  tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
-			  return;
+		case 32:
+			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
+			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
+			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
+			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
+			tmp[16] = 0; tmp[17] = 0; tmp[18] = 0; tmp[19] = 0;
+			tmp[20] = 0; tmp[21] = 0; tmp[22] = 0; tmp[23] = 0;
+			tmp[24] = 0; tmp[25] = 0; tmp[26] = 0; tmp[27] = 0;
+			tmp[28] = 0; tmp[29] = 0; tmp[30] = 0; tmp[31] = 0;
+			return;
+		case 16:
+			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
+			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
+			tmp[ 8] = 0; tmp[ 9] = 0; tmp[10] = 0; tmp[11] = 0;
+			tmp[12] = 0; tmp[13] = 0; tmp[14] = 0; tmp[15] = 0;
+			return;
+		case 8:
+			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
+			tmp[ 4] = 0; tmp[ 5] = 0; tmp[ 6] = 0; tmp[ 7] = 0;
+			return;
+		case 4:
+			tmp[ 0] = 0; tmp[ 1] = 0; tmp[ 2] = 0; tmp[ 3] = 0;
+			return;
 		}
 	}
 	i = __FDSET_LONGS;
-- 
1.5.4.rc2

