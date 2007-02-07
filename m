Return-Path: <linux-kernel-owner+w=401wt.eu-S1422924AbXBGT4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422924AbXBGT4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161424AbXBGTzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:55:45 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34323 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1161430AbXBGTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:55:25 -0500
Message-Id: <200702071947.l17Jlo57006625@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 6/7] UML - register handling formatting fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 07 Feb 2007 14:47:50 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Formatting fixes in the register handling code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/sys-i386/registers.c   |   14 +++++++-------
 arch/um/os-Linux/sys-x86_64/registers.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/sys-i386/registers.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/sys-i386/registers.c	2007-01-09 15:17:55.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/sys-i386/registers.c	2007-01-09 15:45:22.000000000 -0500
@@ -34,27 +34,27 @@ void init_thread_registers(union uml_pt_
 int save_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 int restore_fp_registers(int pid, unsigned long *fp_regs)
 {
 	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
-		return(-errno);
-	return(0);
+		return -errno;
+	return 0;
 }
 
 static int move_registers(int pid, int int_op, union uml_pt_regs *regs,
 			  int fp_op, unsigned long *fp_regs)
 {
 	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return(-errno);
+		return -errno;
 
 	if(ptrace(fp_op, pid, 0, fp_regs) < 0)
-		return(-errno);
+		return -errno;
 
-	return(0);
+	return 0;
 }
 
 void save_registers(int pid, union uml_pt_regs *regs)
Index: linux-2.6.18-mm/arch/um/os-Linux/sys-x86_64/registers.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/sys-x86_64/registers.c	2007-01-09 15:17:53.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/sys-x86_64/registers.c	2007-01-09 15:45:22.000000000 -0500
@@ -27,12 +27,12 @@ static int move_registers(int pid, int i
 			  union uml_pt_regs *regs)
 {
 	if(ptrace(int_op, pid, 0, regs->skas.regs) < 0)
-		return(-errno);
+		return -errno;
 
 	if(ptrace(fp_op, pid, 0, regs->skas.fp) < 0)
-		return(-errno);
+		return -errno;
 
-	return(0);
+	return 0;
 }
 
 void save_registers(int pid, union uml_pt_regs *regs)

