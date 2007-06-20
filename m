Return-Path: <linux-kernel-owner+w=401wt.eu-S1763257AbXFTSn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763257AbXFTSn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbXFTSb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54755 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756254AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183007.619153294@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:15 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [08/37] Use page_cache_xxx in mm/migrate.c
Content-Disposition: inline; filename=vps_mm_migrate
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: vps/mm/migrate.c
===================================================================
--- vps.orig/mm/migrate.c	2007-06-11 15:56:37.000000000 -0700
+++ vps/mm/migrate.c	2007-06-11 22:05:16.000000000 -0700
@@ -196,7 +196,7 @@ static void remove_file_migration_ptes(s
 	struct vm_area_struct *vma;
 	struct address_space *mapping = page_mapping(new);
 	struct prio_tree_iter iter;
-	pgoff_t pgoff = new->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = new->index << mapping_order(mapping);
 
 	if (!mapping)
 		return;

-- 
