Return-Path: <linux-kernel-owner+w=401wt.eu-S965442AbXAWTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442AbXAWTfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965416AbXAWTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:34:57 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:33092 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965422AbXAWTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:55 -0500
Message-Id: <200701231927.l0NJRj1w005358@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 5/7] UML - style fixes in startup code
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jan 2007 14:27:45 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some style fixes in startup.c.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/start_up.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/start_up.c	2007-01-13 17:58:49.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/start_up.c	2007-01-13 18:00:47.000000000 +1100
@@ -95,7 +95,7 @@ static int start_ptraced_child(void **st
 		      status);
 
 	*stack_out = stack;
-	return(pid);
+	return pid;
 }
 
 /* When testing for SYSEMU support, if it is one of the broken versions, we
@@ -182,7 +182,7 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 static void __init check_sysemu(void)
 {
 	void *stack;
- 	int pid, n, status, count=0;
+	int pid, n, status, count=0;
 
 	printf("Checking syscall emulation patch for ptrace...");
 	sysemu_supported = 0;
@@ -418,7 +418,7 @@ static inline void check_skas3_proc_mm(v
 {
 	printf("  - /proc/mm...");
 	if (os_access("/proc/mm", OS_ACC_W_OK) < 0) {
- 		proc_mm = 0;
+		proc_mm = 0;
 		printf("not found\n");
 	}
 	else {
@@ -445,7 +445,7 @@ int can_do_skas(void)
 #else
 int can_do_skas(void)
 {
-	return(0);
+	return 0;
 }
 #endif
 
@@ -493,11 +493,11 @@ int __init parse_iomem(char *str, int *a
 	iomem_regions = new;
 	iomem_size += new->size + UM_KERN_PAGE_SIZE;
 
-	return(0);
+	return 0;
  out_close:
 	os_close_file(fd);
  out:
-	return(1);
+	return 1;
 }
 
 

