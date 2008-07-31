Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGaXvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGaXvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYGaXvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:51:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:28225 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYGaXvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=yEHdM+ENlCu1uxovK9X7qb8iYrv/nxNTrnfuUl2ub+wxrP9bEOY8ebTVBHrmw+9MO+
         HSNWez+80N45rjzQWwrBXJbE2UtuaAkE7C6Pni61EKh4lbELdouwscmjcVNk+1lEiaYP
         t7Vgh6uUa9YldXpxxZHwayyycCU1zZQX2KQfc=
Date: Fri, 1 Aug 2008 03:51:38 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: [PATCH] x86_64: remove empty lines from stack traces/oopses
Message-ID: <20080731235137.GA4816@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/kernel/traps_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -339,9 +339,8 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
-	printk("\nCall Trace:\n");
+	printk("Call Trace:\n");
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("\n");
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
@@ -386,6 +385,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
+	printk("\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
@@ -443,7 +443,6 @@ void show_registers(struct pt_regs *regs)
 		printk("Stack: ");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
 				regs->bp, "");
-		printk("\n");
 
 		printk(KERN_EMERG "Code: ");
 

