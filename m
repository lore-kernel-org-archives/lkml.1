Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYHAUI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYHAUI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYHAUIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:08:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54062 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752704AbYHAUIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:08:20 -0400
Date: Fri, 1 Aug 2008 15:08:15 -0500
From: Jack Steiner <steiner@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com, akpm@linux-foundation.org
Subject: [PATCH] - Remove EXPORTS of follow_page & zap_page_range
Message-ID: <20080801200815.GA11816@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete 2 EXPORTs that were accidentally sent upstream.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-08-01 14:42:33.000000000 -0500
+++ linux-2.6/mm/memory.c	2008-08-01 15:04:20.000000000 -0500
@@ -993,7 +993,6 @@ unsigned long zap_page_range(struct vm_a
 		tlb_finish_mmu(tlb, address, end);
 	return end;
 }
-EXPORT_SYMBOL_GPL(zap_page_range);
 
 /**
  * zap_vma_ptes - remove ptes mapping the vma
@@ -1111,7 +1110,6 @@ no_page_table:
 	}
 	return page;
 }
-EXPORT_SYMBOL_GPL(follow_page);
 
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
