Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYACPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYACPtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbYACPq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:46:29 -0500
Received: from ns1.suse.de ([195.135.220.2]:48988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759934AbYACPq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:46:28 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080103446.461669000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] X86: Use shorter addresses in i386 segfault printks
Date: Thu,  3 Jan 2008 16:46:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/fault_32.c
===================================================================
--- linux.orig/arch/x86/mm/fault_32.c
+++ linux/arch/x86/mm/fault_32.c
@@ -549,7 +549,7 @@ bad_area_nosemaphore:
 
 		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
 		    printk_ratelimit()) {
-			printk("%s%s[%d]: segfault at %08lx ip %08lx "
+			printk("%s%s[%d]: segfault at %lx ip %08lx "
 			    "sp %08lx error %lx\n",
 			    task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
 			    tsk->comm, task_pid_nr(tsk), address, regs->ip,
