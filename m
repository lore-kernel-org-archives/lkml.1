Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYCWI0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYCWI0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759430AbYCWIJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:22 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2277 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759413AbYCWIJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:21 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 083/148] include/asm-x86/page_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:58 -0700
Message-Id: <1206259443-13210-84-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/page_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index aee05c6..f156778 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -5,7 +5,7 @@
 
 #define THREAD_ORDER	1
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
-#define CURRENT_MASK (~(THREAD_SIZE-1))
+#define CURRENT_MASK (~(THREAD_SIZE - 1))
 
 #define EXCEPTION_STACK_ORDER 0
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
@@ -51,7 +51,7 @@
  * Kernel image size is limited to 512 MB (see level2_kernel_pgt in
  * arch/x86/kernel/head_64.S), and it is mapped here:
  */
-#define KERNEL_IMAGE_SIZE	(512*1024*1024)
+#define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
 #define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
 #ifndef __ASSEMBLY__
-- 
1.5.4.rc2

