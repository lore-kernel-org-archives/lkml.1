Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbZEBUBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbZEBUBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbZEBUBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:01:32 -0400
Received: from www.tglx.de ([62.245.132.106]:55702 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbZEBUBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:01:31 -0400
Message-Id: <20090502195925.263615612@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:00:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [patch 02/11] sh: remove obsolete no_irq_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline; filename=sh-remove-obsolete-no-irq-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

convert the last remaining users to no_irq_chip

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/sh_ksyms_32.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/sh/kernel/sh_ksyms_32.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/sh_ksyms_32.c
+++ linux-2.6/arch/sh/kernel/sh_ksyms_32.c
@@ -19,13 +19,12 @@
 #include <asm/ftrace.h>
 
 extern int dump_fpu(struct pt_regs *, elf_fpregset_t *);
-extern struct hw_interrupt_type no_irq_type;
 
 /* platform dependent support */
 EXPORT_SYMBOL(dump_fpu);
 EXPORT_SYMBOL(kernel_thread);
 EXPORT_SYMBOL(irq_desc);
-EXPORT_SYMBOL(no_irq_type);
+EXPORT_SYMBOL(no_irq_chip);
 
 EXPORT_SYMBOL(strlen);
 


