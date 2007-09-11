Return-Path: <linux-kernel-owner+w=401wt.eu-S966074AbXIKGLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966074AbXIKGLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965305AbXIKGFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50554 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761390AbXIKGEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:31 -0400
Message-Id: <20070911060427.125710022@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:03:58 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [08/41] Use page_cache_xxx in mm/migrate.c
Content-Disposition: inline; filename=0008-Use-page_cache_xxx-in-mm-migrate.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in mm/migrate.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 37c73b9..4949927 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -195,7 +195,7 @@ static void remove_file_migration_ptes(struct page *old, struct page *new)
 	struct vm_area_struct *vma;
 	struct address_space *mapping = page_mapping(new);
 	struct prio_tree_iter iter;
-	pgoff_t pgoff = new->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = new->index << mapping_order(mapping);
 
 	if (!mapping)
 		return;
-- 
1.5.2.5

-- 
