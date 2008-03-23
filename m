Return-Path: <linux-kernel-owner+w=401wt.eu-S934756AbYCWJH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbYCWJH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760355AbYCWIM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:29 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2377 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760253AbYCWIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 121/148] include/asm-x86/suspend_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:36 -0700
Message-Id: <1206259443-13210-122-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/suspend_64.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/suspend_64.h b/include/asm-x86/suspend_64.h
index 2eb92cb..dc3262b 100644
--- a/include/asm-x86/suspend_64.h
+++ b/include/asm-x86/suspend_64.h
@@ -9,8 +9,7 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 
-static inline int
-arch_prepare_suspend(void)
+static inline int arch_prepare_suspend(void)
 {
 	return 0;
 }
@@ -25,7 +24,7 @@ arch_prepare_suspend(void)
  */
 struct saved_context {
 	struct pt_regs regs;
-  	u16 ds, es, fs, gs, ss;
+	u16 ds, es, fs, gs, ss;
 	unsigned long gs_base, gs_kernel_base, fs_base;
 	unsigned long cr0, cr2, cr3, cr4, cr8;
 	unsigned long efer;
-- 
1.5.4.rc2

