Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXJXCEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXJXCEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXJXCEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:01 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34291 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752645AbXJXCEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:00 -0400
Date: Wed, 24 Oct 2007 12:03:10 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240203.l9O23AuS016632@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove unused variables in setup.c
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variables from setup.c code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/kernel/setup.c linux-2.6.23-uc0/arch/m68knommu/kernel/setup.c
--- linux-2.6.23/arch/m68knommu/kernel/setup.c	2007-10-19 10:30:54.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/kernel/setup.c	2007-10-19 10:35:38.000000000 +1000
@@ -43,11 +43,8 @@ EXPORT_SYMBOL(memory_end);
 char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* machine dependent timer functions */
-void (*mach_sched_init)(irq_handler_t handler);
-void (*mach_tick)(void);
 void (*mach_gettod)(int*, int*, int*, int*, int*, int*);
 int (*mach_set_clock_mmss)(unsigned long);
-unsigned long (*mach_gettimeoffset)(void);
 
 /* machine dependent reboot functions */
 void (*mach_reset)(void);
