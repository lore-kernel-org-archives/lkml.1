Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbYCWIwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbYCWIwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbYCWILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:40 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2337 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760081AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 041/148] include/asm-x86/hw_irq_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:16 -0700
Message-Id: <1206259443-13210-42-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/hw_irq_64.h |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/hw_irq_64.h b/include/asm-x86/hw_irq_64.h
index 312a58d..0062ef3 100644
--- a/include/asm-x86/hw_irq_64.h
+++ b/include/asm-x86/hw_irq_64.h
@@ -36,7 +36,7 @@
  * cleanup after irq migration.
  */
 #define IRQ_MOVE_CLEANUP_VECTOR	FIRST_EXTERNAL_VECTOR
- 
+
 /*
  * Vectors 0x30-0x3f are used for ISA interrupts.
  */
@@ -159,13 +159,12 @@ extern atomic_t irq_mis_count;
  *	SMP has a few special interrupts for IPI messages
  */
 
-#define BUILD_IRQ(nr) \
-asmlinkage void IRQ_NAME(nr); \
-__asm__( \
-"\n.p2align\n" \
-"IRQ" #nr "_interrupt:\n\t" \
-	"push $~(" #nr ") ; " \
-	"jmp common_interrupt");
+#define BUILD_IRQ(nr)				\
+	asmlinkage void IRQ_NAME(nr);		\
+	asm("\n.p2align\n"			\
+	    "IRQ" #nr "_interrupt:\n\t"		\
+	    "push $~(" #nr ") ; "		\
+	    "jmp common_interrupt");
 
 #define platform_legacy_irq(irq)	((irq) < 16)
 
-- 
1.5.4.rc2

