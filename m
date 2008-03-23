Return-Path: <linux-kernel-owner+w=401wt.eu-S1763181AbYCWJBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181AbYCWJBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760163AbYCWIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:07 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2350 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760157AbYCWILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 009/148] include/asm-x86/bitops_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:44 -0700
Message-Id: <1206259443-13210-10-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/bitops_64.h |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
index 63b439b..d133520 100644
--- a/include/asm-x86/bitops_64.h
+++ b/include/asm-x86/bitops_64.h
@@ -15,25 +15,25 @@ static inline long __scanbit(unsigned long val, unsigned long max)
 	return val;
 }
 
-#define find_first_bit(addr,size) \
-((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? \
-  (__scanbit(*(unsigned long *)addr,(size))) : \
-  find_first_bit(addr,size)))
-
-#define find_first_zero_bit(addr,size) \
-((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? \
-  (__scanbit(~*(unsigned long *)addr,(size))) : \
-  	find_first_zero_bit(addr,size)))
-	
-static inline void set_bit_string(unsigned long *bitmap, unsigned long i, 
-				  int len) 
-{ 
-	unsigned long end = i + len; 
+#define find_first_bit(addr, size)					\
+	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
+	  ? (__scanbit(*(unsigned long *)(addr), (size)))		\
+	  : find_first_bit((addr), (size))))
+
+#define find_first_zero_bit(addr, size)					\
+	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
+	  ? (__scanbit(~*(unsigned long *)(addr), (size)))		\
+	  : find_first_zero_bit((addr), (size))))
+
+static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
+				  int len)
+{
+	unsigned long end = i + len;
 	while (i < end) {
-		__set_bit(i, bitmap); 
+		__set_bit(i, bitmap);
 		i++;
 	}
-} 
+}
 
 #ifdef __KERNEL__
 
@@ -51,10 +51,10 @@ static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
-#define ext2_set_bit_atomic(lock,nr,addr) \
-	        test_and_set_bit((nr),(unsigned long*)addr)
-#define ext2_clear_bit_atomic(lock,nr,addr) \
-	        test_and_clear_bit((nr),(unsigned long*)addr)
+#define ext2_set_bit_atomic(lock, nr, addr)			\
+	test_and_set_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)			\
+	test_and_clear_bit((nr), (unsigned long *)(addr))
 
 #include <asm-generic/bitops/minix.h>
 
-- 
1.5.4.rc2

