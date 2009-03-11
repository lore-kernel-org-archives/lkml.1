Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZCKArw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZCKArw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZCKAqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:40 -0400
Received: from www.tglx.de ([62.245.132.106]:40022 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZCKAqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:39 -0400
Message-Id: <20090311003235.802890078@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [patch 04/18] sh: convert obsolete no_irq_type to no_irq_chip
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline; filename=sh-convert-obsolete-no-irq-type.patch
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
 


