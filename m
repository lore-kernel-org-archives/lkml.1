Return-Path: <linux-kernel-owner+w=401wt.eu-S1422717AbXBGTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717AbXBGTzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422916AbXBGTzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:55:03 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34298 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422908AbXBGTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:57 -0500
Message-Id: <200702071947.l17Jljei006610@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 3/7] UML - SIGIO formatting fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 07 Feb 2007 14:47:45 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix formatting in the sigio code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/sigio.h |   11 -----------
 arch/um/kernel/sigio.c  |    6 +++---
 2 files changed, 3 insertions(+), 14 deletions(-)

Index: linux-2.6.18-mm/arch/um/include/sigio.h
===================================================================
--- linux-2.6.18-mm.orig/arch/um/include/sigio.h	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.18-mm/arch/um/include/sigio.h	2007-01-09 15:16:29.000000000 -0500
@@ -12,14 +12,3 @@ extern void sigio_lock(void);
 extern void sigio_unlock(void);
 
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
Index: linux-2.6.18-mm/arch/um/kernel/sigio.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/sigio.c	2007-01-09 15:12:08.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/sigio.c	2007-01-09 15:15:59.000000000 -0500
@@ -23,7 +23,7 @@ static irqreturn_t sigio_interrupt(int i
 
 	os_read_file(sigio_irq_fd, &c, sizeof(c));
 	reactivate_fd(sigio_irq_fd, SIGIO_WRITE_IRQ);
-	return(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 int write_sigio_irq(int fd)
@@ -36,10 +36,10 @@ int write_sigio_irq(int fd)
 	if(err){
 		printk("write_sigio_irq : um_request_irq failed, err = %d\n",
 		       err);
-		return(-1);
+		return -1;
 	}
 	sigio_irq_fd = fd;
-	return(0);
+	return 0;
 }
 
 /* These are called from os-Linux/sigio.c to protect its pollfds arrays. */

