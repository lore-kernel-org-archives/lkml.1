Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbYCWIdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbYCWIdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbYCWIKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:05 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2296 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759661AbYCWIKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:02 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 120/148] include/asm-x86/suspend_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:35 -0700
Message-Id: <1206259443-13210-121-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/suspend_32.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/suspend_32.h b/include/asm-x86/suspend_32.h
index 1bbda3a..24e1c08 100644
--- a/include/asm-x86/suspend_32.h
+++ b/include/asm-x86/suspend_32.h
@@ -10,7 +10,7 @@ static inline int arch_prepare_suspend(void) { return 0; }
 
 /* image of the saved processor state */
 struct saved_context {
-  	u16 es, fs, gs, ss;
+	u16 es, fs, gs, ss;
 	unsigned long cr0, cr2, cr3, cr4;
 	struct desc_ptr gdt;
 	struct desc_ptr idt;
@@ -32,11 +32,11 @@ extern unsigned long saved_edi;
 static inline void acpi_save_register_state(unsigned long return_point)
 {
 	saved_eip = return_point;
-	asm volatile ("movl %%esp,%0" : "=m" (saved_esp));
-	asm volatile ("movl %%ebp,%0" : "=m" (saved_ebp));
-	asm volatile ("movl %%ebx,%0" : "=m" (saved_ebx));
-	asm volatile ("movl %%edi,%0" : "=m" (saved_edi));
-	asm volatile ("movl %%esi,%0" : "=m" (saved_esi));
+	asm volatile("movl %%esp,%0" : "=m" (saved_esp));
+	asm volatile("movl %%ebp,%0" : "=m" (saved_ebp));
+	asm volatile("movl %%ebx,%0" : "=m" (saved_ebx));
+	asm volatile("movl %%edi,%0" : "=m" (saved_edi));
+	asm volatile("movl %%esi,%0" : "=m" (saved_esi));
 }
 
 #define acpi_restore_register_state()  do {} while (0)
-- 
1.5.4.rc2

