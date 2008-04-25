Return-Path: <linux-kernel-owner+w=401wt.eu-S1765238AbYDYSIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765238AbYDYSIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764837AbYDYR5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:37 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53139 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762841AbYDYR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:21 -0400
Date: Fri, 25 Apr 2008 13:56:08 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/19] UML - Style fixes
Message-ID: <20080425175606.GA11176@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few random style fixes.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/skas_ptrace.h            |   13 +------------
 arch/um/include/sysdep-i386/sigcontext.h |    2 +-
 arch/um/kernel/um_arch.c                 |    2 +-
 arch/um/os-Linux/skas/process.c          |    2 +-
 4 files changed, 4 insertions(+), 15 deletions(-)

Index: linux-2.6-git/arch/um/include/skas_ptrace.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/skas_ptrace.h	2008-02-21 18:47:34.000000000 -0500
+++ linux-2.6-git/arch/um/include/skas_ptrace.h	2008-03-06 09:46:19.000000000 -0500
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -12,14 +12,3 @@
 #include "sysdep/skas_ptrace.h"
 
 #endif
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
Index: linux-2.6-git/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/skas/process.c	2008-02-26 10:26:40.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/skas/process.c	2008-03-06 09:46:19.000000000 -0500
@@ -442,7 +442,7 @@ void userspace(struct uml_pt_regs *regs)
 				unblock_signals();
 				break;
 			default:
-			        printk(UM_KERN_ERR "userspace - child stopped "
+				printk(UM_KERN_ERR "userspace - child stopped "
 				       "with signal %d\n", sig);
 				fatal_sigsegv();
 			}
Index: linux-2.6-git/arch/um/include/sysdep-i386/sigcontext.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/sysdep-i386/sigcontext.h	2008-02-21 18:47:34.000000000 -0500
+++ linux-2.6-git/arch/um/include/sysdep-i386/sigcontext.h	2008-03-06 09:46:19.000000000 -0500
@@ -10,7 +10,7 @@
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
-#define GET_FAULTINFO_FROM_SC(fi,sc) \
+#define GET_FAULTINFO_FROM_SC(fi, sc) \
 	{ \
 		(fi).cr2 = SC_CR2(sc); \
 		(fi).error_code = SC_ERR(sc); \
Index: linux-2.6-git/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/um_arch.c	2008-02-21 18:47:34.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/um_arch.c	2008-03-06 09:46:19.000000000 -0500
@@ -150,7 +150,7 @@ __uml_setup("root=", uml_root_setup,
 static int __init no_skas_debug_setup(char *line, int *add)
 {
 	printf("'debug' is not necessary to gdb UML in skas mode - run \n");
-	printf("'gdb linux'");
+	printf("'gdb linux'\n");
 
 	return 0;
 }
