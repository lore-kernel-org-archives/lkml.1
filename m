Return-Path: <linux-kernel-owner+w=401wt.eu-S1031487AbXDZUA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031487AbXDZUA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031480AbXDZUAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:00:52 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49650 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031487AbXDZUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:00:32 -0400
Date: Thu, 26 Apr 2007 15:56:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/5] UML - Eliminate a piece of debugging code
Message-ID: <20070426195621.GA9558@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I missed removing another piece of debugging in an earlier patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/tlb.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tlb.c	2007-04-25 13:34:08.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tlb.c	2007-04-25 13:34:27.000000000 -0400
@@ -252,7 +252,6 @@ void fix_range_common(struct mm_struct *
 					    &op_index, force, mmu, &flush,
 					    do_ops);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
-	log_info("total flush time - %Ld nsecs\n", end_time - start_time);
 
 	if(!ret)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
