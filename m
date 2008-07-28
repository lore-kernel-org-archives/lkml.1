Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbYG1VKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbYG1VKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYG1VJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:35 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYG1VJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:34 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 03/24] x86: kernel/asm-offsets_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:10 -0300
Message-Id: <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/asm-offsets_64.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index aa89387..72d1f6c 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -5,9 +5,9 @@
  */
 
 #include <linux/crypto.h>
-#include <linux/sched.h> 
+#include <linux/sched.h>
 #include <linux/stddef.h>
-#include <linux/errno.h> 
+#include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/suspend.h>
 #include <linux/kbuild.h>
@@ -32,7 +32,7 @@ int main(void)
 {
 #define ENTRY(entry) DEFINE(tsk_ ## entry, offsetof(struct task_struct, entry))
 	ENTRY(state);
-	ENTRY(flags); 
+	ENTRY(flags);
 	ENTRY(pid);
 	BLANK();
 #undef ENTRY
@@ -47,9 +47,9 @@ int main(void)
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))
-	ENTRY(kernelstack); 
-	ENTRY(oldrsp); 
-	ENTRY(pcurrent); 
+	ENTRY(kernelstack);
+	ENTRY(oldrsp);
+	ENTRY(pcurrent);
 	ENTRY(irqcount);
 	ENTRY(cpunumber);
 	ENTRY(irqstackptr);
-- 
1.5.4.5

