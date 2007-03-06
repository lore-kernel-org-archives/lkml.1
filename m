Return-Path: <linux-kernel-owner+w=401wt.eu-S965999AbXCFSl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965999AbXCFSl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966013AbXCFSl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:41:27 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53051 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbXCFSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:41:24 -0500
Message-Id: <200703061832.l26IW6BK006549@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 1/5] UML - Mark tt-mode code for future removal
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 06 Mar 2007 13:32:06 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark some tt-mode-only code as such.

Also cleaned up some formatting.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/sys-i386/ptrace_user.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

Index: linux-2.6.18-mm/arch/um/sys-i386/ptrace_user.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-i386/ptrace_user.c	2007-03-02 21:18:13.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-i386/ptrace_user.c	2007-03-02 21:23:19.000000000 -0500
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -45,7 +45,8 @@ int ptrace_setfpregs(long pid, unsigned 
 	return 0;
 }
 
-/* All the below stuff is of interest for TT mode only */
+#ifdef UML_CONFIG_MODE_TT
+
 static void write_debugregs(int pid, unsigned long *regs)
 {
 	struct user *dummy;
@@ -128,13 +129,4 @@ void update_debugregs(int seq)
 }
 #endif
 
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
+#endif

