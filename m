Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXCJVaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXCJVaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbXCJVaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:30:39 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:49683 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXCJVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:30:38 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 16:27:30 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: jdike@karaya.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] USER-MODE LINUX: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101624530.27918@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete the apparently unused header file
arch/um/kernel/tt/include/mode_kern-tt.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this one i'm not so sure about as there is a header file named
"mode_kern_tt.h", and those names are uncomfortably similar.



diff --git a/arch/um/kernel/tt/include/mode_kern-tt.h b/arch/um/kernel/tt/include/mode_kern-tt.h
deleted file mode 100644
index 2a35b15..0000000
--- a/arch/um/kernel/tt/include/mode_kern-tt.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __TT_MODE_KERN_H__
-#define __TT_MODE_KERN_H__
-
-#include "linux/sched.h"
-#include "asm/page.h"
-#include "asm/ptrace.h"
-#include "asm/uaccess.h"
-
-extern void switch_to_tt(void *prev, void *next);
-extern void flush_thread_tt(void);
-extern void start_thread_tt(struct pt_regs *regs, unsigned long eip,
-			   unsigned long esp);
-extern int copy_thread_tt(int nr, unsigned long clone_flags, unsigned long sp,
-			  unsigned long stack_top, struct task_struct *p,
-			  struct pt_regs *regs);
-extern void release_thread_tt(struct task_struct *task);
-extern void initial_thread_cb_tt(void (*proc)(void *), void *arg);
-extern void init_idle_tt(void);
-extern void flush_tlb_kernel_range_tt(unsigned long start, unsigned long end);
-extern void flush_tlb_kernel_vm_tt(void);
-extern void __flush_tlb_one_tt(unsigned long addr);
-extern void flush_tlb_range_tt(struct vm_area_struct *vma,
-			       unsigned long start, unsigned long end);
-extern void flush_tlb_mm_tt(struct mm_struct *mm);
-extern void force_flush_all_tt(void);
-extern long execute_syscall_tt(void *r);
-extern void before_mem_tt(unsigned long brk_start);
-extern unsigned long set_task_sizes_tt(int arg, unsigned long *host_size_out,
-				       unsigned long *task_size_out);
-extern int start_uml_tt(void);
-extern int external_pid_tt(struct task_struct *task);
-extern int thread_pid_tt(struct task_struct *task);
-
-#define kmem_end_tt (host_task_size - ABOVE_KMEM)
-
-#endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
