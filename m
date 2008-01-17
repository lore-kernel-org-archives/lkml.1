Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYAQVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYAQVlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYAQVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:17 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44734 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbYAQVlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:16 -0500
Date: Thu, 17 Jan 2008 16:40:43 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/20] UML - Add newlines to printks
Message-ID: <20080117214043.GA6732@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some printks were missing newlines.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/skas/process.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2007-12-19 13:13:54.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2007-12-19 13:14:16.000000000 -0500
@@ -273,7 +273,7 @@ int start_userspace(unsigned long stub_s
 	if (stack == MAP_FAILED) {
 		err = -errno;
 		printk(UM_KERN_ERR "start_userspace : mmap failed, "
-		       "errno = %d", errno);
+		       "errno = %d\n", errno);
 		return err;
 	}
 
@@ -289,7 +289,7 @@ int start_userspace(unsigned long stub_s
 	if (pid < 0) {
 		err = -errno;
 		printk(UM_KERN_ERR "start_userspace : clone failed, "
-		       "errno = %d", errno);
+		       "errno = %d\n", errno);
 		return err;
 	}
 
@@ -298,7 +298,7 @@ int start_userspace(unsigned long stub_s
 		if (n < 0) {
 			err = -errno;
 			printk(UM_KERN_ERR "start_userspace : wait failed, "
-			       "errno = %d", errno);
+			       "errno = %d\n", errno);
 			goto out_kill;
 		}
 	} while (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGVTALRM));
@@ -306,7 +306,7 @@ int start_userspace(unsigned long stub_s
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP)) {
 		err = -EINVAL;
 		printk(UM_KERN_ERR "start_userspace : expected SIGSTOP, got "
-		       "status = %d", status);
+		       "status = %d\n", status);
 		goto out_kill;
 	}
 
