Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbXG0Ajd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbXG0Ajd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761395AbXG0Aiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:38:51 -0400
Received: from rex.snapgear.com ([203.143.235.140]:36582 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760929AbXG0Aiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:38:50 -0400
Date: Fri, 27 Jul 2007 10:38:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707270038.l6R0c1Hc006630@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix declaration of mach_sched_init
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make declaration of mach_sched_init match definition
(which is in arch/m68knommu/kernel/setup.c).

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/include/asm-m68knommu/machdep.h linux/include/asm-m68knommu/machdep.h
--- linux-2.6.23-rc1-git2/include/asm-m68knommu/machdep.h	2007-07-26 10:39:14.000000000 +1000
+++ linux/include/asm-m68knommu/machdep.h	2007-07-26 22:39:53.000000000 +1000
@@ -11,7 +11,7 @@
 struct gendisk;
 struct buffer_head;
 
-extern void (*mach_sched_init) (irqreturn_t (*handler)(int, void *, struct pt_regs *));
+extern void (*mach_sched_init) (irq_handler_t handler);
 /* machine dependent keyboard functions */
 extern int (*mach_keyb_init) (void);
 extern int (*mach_kbdrate) (struct kbd_repeat *);
