Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXFNTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXFNTn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXFNTlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:41:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50446 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbXFNTkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:40:55 -0400
Message-Id: <20070614194054.304101692@sgi.com>
References: <20070614193839.878721298@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 12:38:47 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [patch 08/14] Use page_cache_xx in mm/migrate.c
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
