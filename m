Return-Path: <linux-kernel-owner+w=401wt.eu-S1767286AbXDEU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767286AbXDEU3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXDEU3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:29:18 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:54272 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbXDEU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:29:16 -0400
Date: Thu, 5 Apr 2007 16:24:52 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/4] UML - Delete HOST_FRAME_SIZE
Message-ID: <20070405202452.GA8929@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HOST_FRAME_SIZE isn't used any more.  It has been replaced with MAX_REG_NR.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/sys-i386/user-offsets.c   |    1 -
 arch/um/sys-x86_64/user-offsets.c |    1 -
 2 files changed, 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/sys-i386/user-offsets.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-i386/user-offsets.c	2007-04-05 12:38:56.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-i386/user-offsets.c	2007-04-05 12:39:12.000000000 -0400
@@ -47,7 +47,6 @@ void foo(void)
 	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
 	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
-	DEFINE(HOST_FRAME_SIZE, FRAME_SIZE);
 	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_i387_struct));
 	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fxsr_struct));
 
Index: linux-2.6.21-mm/arch/um/sys-x86_64/user-offsets.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-x86_64/user-offsets.c	2007-04-05 12:38:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-x86_64/user-offsets.c	2007-04-05 12:39:12.000000000 -0400
@@ -57,7 +57,6 @@ void foo(void)
 	OFFSET(HOST_SC_SS, sigcontext, ss);
 #endif
 
-	DEFINE_LONGS(HOST_FRAME_SIZE, FRAME_SIZE);
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 	DEFINE(HOST_XFP_SIZE, 0);
 	DEFINE_LONGS(HOST_RBX, RBX);
