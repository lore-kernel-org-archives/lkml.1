Return-Path: <linux-kernel-owner+w=401wt.eu-S941110AbXGSSDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941110AbXGSSDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936432AbXGSSCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:02:51 -0400
Received: from verein.lst.de ([213.95.11.210]:49473 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937953AbXGSSCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:02:50 -0400
Date: Thu, 19 Jul 2007 20:02:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove handle_mm_fault export
Message-ID: <20070719180235.GA22297@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/powerpc/platforms/cell/spufs/fault.c is always built in
the kernel there is no need to export handle_mm_fault anymore.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-07-19 18:59:50.000000000 +0200
+++ linux-2.6/mm/memory.c	2007-07-19 18:59:56.000000000 +0200
@@ -2659,8 +2659,6 @@ int handle_mm_fault(struct mm_struct *mm
 	return handle_pte_fault(mm, vma, address, pte, pmd, write_access);
 }
 
-EXPORT_SYMBOL_GPL(handle_mm_fault);
-
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * Allocate page upper directory.
