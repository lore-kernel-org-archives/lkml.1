Return-Path: <linux-kernel-owner+w=401wt.eu-S966566AbXEGUZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966566AbXEGUZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966544AbXEGUZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:25:37 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60205 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966534AbXEGUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:25:30 -0400
Date: Mon, 7 May 2007 16:20:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/5] Fix Linuxdoc comment
Message-ID: <20070507202019.GA8512@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A linuxdoc comment had fallen out of date - it refers to an argument
which no longer exists.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 kernel/irq/handle.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.21-mm/kernel/irq/handle.c
===================================================================
--- linux-2.6.21-mm.orig/kernel/irq/handle.c	2007-05-02 11:21:45.000000000 -0400
+++ linux-2.6.21-mm/kernel/irq/handle.c	2007-05-04 14:53:58.000000000 -0400
@@ -22,7 +22,6 @@
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
  * @desc:      description of the interrupt
- * @regs:      pointer to a register structure
  *
  * Handles spurious and unhandled IRQ's. It also prints a debugmessage.
  */
