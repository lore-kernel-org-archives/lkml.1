Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYCWIHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYCWIHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYCWIHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:32 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1883 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYCWIHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:30 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 011/148] include/asm-x86/bug.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:46 -0700
Message-Id: <1206259443-13210-12-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/bug.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/asm-x86/bug.h b/include/asm-x86/bug.h
index 8d477a2..b69aa64 100644
--- a/include/asm-x86/bug.h
+++ b/include/asm-x86/bug.h
@@ -12,25 +12,25 @@
 # define __BUG_C0	"2:\t.quad 1b, %c0\n"
 #endif
 
-#define BUG()								\
-	do {								\
-		asm volatile("1:\tud2\n"				\
-			     ".pushsection __bug_table,\"a\"\n"		\
-			     __BUG_C0					\
-			     "\t.word %c1, 0\n"				\
-			     "\t.org 2b+%c2\n"				\
-			     ".popsection"				\
-			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (sizeof(struct bug_entry)));		\
-		for(;;) ;						\
-	} while(0)
+#define BUG()							\
+do {								\
+	asm volatile("1:\tud2\n"				\
+		     ".pushsection __bug_table,\"a\"\n"		\
+		     __BUG_C0					\
+		     "\t.word %c1, 0\n"				\
+		     "\t.org 2b+%c2\n"				\
+		     ".popsection"				\
+		     : : "i" (__FILE__), "i" (__LINE__),	\
+		     "i" (sizeof(struct bug_entry)));		\
+	for (;;) ;						\
+} while (0)
 
 #else
-#define BUG()								\
-	do {								\
-		asm volatile("ud2");					\
-		for(;;) ;						\
-	} while(0)
+#define BUG()							\
+do {								\
+	asm volatile("ud2");					\
+	for (;;) ;						\
+} while (0)
 #endif
 
 #endif /* !CONFIG_BUG */
-- 
1.5.4.rc2

