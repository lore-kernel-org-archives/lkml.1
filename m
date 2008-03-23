Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbYCWISM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbYCWISM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbYCWIIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:42 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2256 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbYCWIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 141/148] include/asm-x86/vdso.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:56 -0700
Message-Id: <1206259443-13210-142-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/vdso.h |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/vdso.h b/include/asm-x86/vdso.h
index 9bb8689..6ac2a06 100644
--- a/include/asm-x86/vdso.h
+++ b/include/asm-x86/vdso.h
@@ -8,9 +8,11 @@ extern const char VDSO64_PRELINK[];
  * Given a pointer to the vDSO image, find the pointer to VDSO64_name
  * as that symbol is defined in the vDSO sources or linker script.
  */
-#define VDSO64_SYMBOL(base, name) ({		\
-	extern const char VDSO64_##name[];	\
-	(void *) (VDSO64_##name - VDSO64_PRELINK + (unsigned long) (base)); })
+#define VDSO64_SYMBOL(base, name)
+({									\
+	extern const char VDSO64_##name[];				\
+	(void *)(VDSO64_##name - VDSO64_PRELINK + (unsigned long)(base)); \
+})
 #endif
 
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
@@ -20,9 +22,11 @@ extern const char VDSO32_PRELINK[];
  * Given a pointer to the vDSO image, find the pointer to VDSO32_name
  * as that symbol is defined in the vDSO sources or linker script.
  */
-#define VDSO32_SYMBOL(base, name) ({		\
-	extern const char VDSO32_##name[];	\
-	(void *) (VDSO32_##name - VDSO32_PRELINK + (unsigned long) (base)); })
+#define VDSO32_SYMBOL(base, name)					\
+({									\
+	extern const char VDSO32_##name[];				\
+	(void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)); \
+})
 #endif
 
 /*
-- 
1.5.4.rc2

