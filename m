Return-Path: <linux-kernel-owner+w=401wt.eu-S966577AbXEGUZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966577AbXEGUZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966547AbXEGUZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:25:39 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60206 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbXEGUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:25:35 -0400
Date: Mon, 7 May 2007 16:20:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/5] UML - Mark a tt-only function
Message-ID: <20070507202019.GA8514@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark another function as tt-mode only.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/process.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.21-mm/arch/um/os-Linux/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/process.c	2007-05-02 11:33:18.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/process.c	2007-05-04 14:53:04.000000000 -0400
@@ -239,6 +239,7 @@ out:
 	return ok;
 }
 
+#ifdef UML_CONFIG_MODE_TT
 void init_new_thread_stack(void *sig_stack, void (*usr1_handler)(int))
 {
 	int flags = 0, pages;
@@ -260,6 +261,7 @@ void init_new_thread_stack(void *sig_sta
 			      "errno = %d\n", errno);
 	}
 }
+#endif
 
 void init_new_thread_signals(void)
 {
