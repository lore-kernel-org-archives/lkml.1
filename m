Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbXGZPLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbXGZPLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbXGZPKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:10:20 -0400
Received: from rex.snapgear.com ([203.143.235.140]:47908 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758432AbXGZPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:10:15 -0400
Date: Fri, 27 Jul 2007 01:09:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707261509.l6QF90t5004059@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove unused mach_trap_init
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused mach_trap_init function pointer. All use of it
removed with change to using generic irq framework.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/arch/m68knommu/kernel/setup.c linux/arch/m68knommu/kernel/setup.c
--- linux-2.6.23-rc1-git2/arch/m68knommu/kernel/setup.c	2007-07-26 11:03:08.000000000 +1000
+++ linux/arch/m68knommu/kernel/setup.c	2007-07-26 22:40:20.000000000 +1000
@@ -42,8 +42,6 @@
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-void (*mach_trap_init)(void);
-
 /* machine dependent timer functions */
 void (*mach_sched_init)(irq_handler_t handler);
 void (*mach_tick)(void);
diff -Naur linux-2.6.23-rc1-git2/include/asm-m68knommu/machdep.h linux/include/asm-m68knommu/machdep.h
--- linux-2.6.23-rc1-git2/include/asm-m68knommu/machdep.h	2007-07-26 10:39:14.000000000 +1000
+++ linux/include/asm-m68knommu/machdep.h	2007-07-26 22:39:53.000000000 +1000
@@ -48,6 +48,5 @@
 
 extern void config_BSP(char *command, int len);
 extern void (*mach_tick)(void);
-extern void (*mach_trap_init)(void);
 
 #endif /* _M68KNOMMU_MACHDEP_H */
