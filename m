Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXCEWu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXCEWu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXCEWuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:50:44 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49606 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbXCEWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:50:42 -0500
Message-Id: <200703052241.l25MfK4h008430@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 2/4] UML - Fix formatting violations in signal delivery code
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 05 Mar 2007 17:41:20 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few formatting bugs in the signal code.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/signal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: test/arch/um/kernel/signal.c
===================================================================
--- test.orig/arch/um/kernel/signal.c	2007-03-05 15:07:53.000000000 -0500
+++ test/arch/um/kernel/signal.c	2007-03-05 15:07:54.000000000 -0500
@@ -161,12 +161,12 @@ static int kern_do_signal(struct pt_regs
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
-	return(handled_sig);
+	return handled_sig;
 }
 
 int do_signal(void)
 {
-	return(kern_do_signal(&current->thread.regs));
+	return kern_do_signal(&current->thread.regs);
 }
 
 /*
@@ -189,5 +189,5 @@ long sys_sigsuspend(int history0, int hi
 
 long sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss)
 {
-	return(do_sigaltstack(uss, uoss, PT_REGS_SP(&current->thread.regs)));
+	return do_sigaltstack(uss, uoss, PT_REGS_SP(&current->thread.regs));
 }

