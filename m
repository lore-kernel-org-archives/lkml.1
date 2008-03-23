Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbYCWIUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbYCWIUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759291AbYCWIIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:52 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2266 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759254AbYCWIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:50 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 062/148] include/asm-x86/lguest.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:37 -0700
Message-Id: <1206259443-13210-63-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/lguest.h |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index 9b17571..be4a724 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -34,8 +34,7 @@ extern const char lgstart_iret[], lgend_iret[];
 extern void lguest_iret(void);
 extern void lguest_init(void);
 
-struct lguest_regs
-{
+struct lguest_regs {
 	/* Manually saved part. */
 	unsigned long eax, ebx, ecx, edx;
 	unsigned long esi, edi, ebp;
@@ -51,8 +50,7 @@ struct lguest_regs
 };
 
 /* This is a guest-specific page (mapped ro) into the guest. */
-struct lguest_ro_state
-{
+struct lguest_ro_state {
 	/* Host information we need to restore when we switch back. */
 	u32 host_cr3;
 	struct desc_ptr host_idt_desc;
@@ -67,8 +65,7 @@ struct lguest_ro_state
 	struct desc_struct guest_gdt[GDT_ENTRIES];
 };
 
-struct lg_cpu_arch
-{
+struct lg_cpu_arch {
 	/* The GDT entries copied into lguest_ro_state when running. */
 	struct desc_struct gdt[GDT_ENTRIES];
 
@@ -85,7 +82,7 @@ static inline void lguest_set_ts(void)
 
 	cr0 = read_cr0();
 	if (!(cr0 & 8))
-		write_cr0(cr0|8);
+		write_cr0(cr0 | 8);
 }
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
-- 
1.5.4.rc2

