Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbYCMDuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbYCMDuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYCMDuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:50:00 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43695 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYCMDt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:49:59 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, linux-sparc@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH -mm 2/2] SPARC64: remove unused calc_npages() in iommu_common.h
Date: Thu, 13 Mar 2008 12:47:07 +0900
Message-Id: <1205380027-28230-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1205380027-28230-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205380027-28230-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/iommu_common.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/sparc64/kernel/iommu_common.h b/arch/sparc64/kernel/iommu_common.h
index 87ace49..f3575a6 100644
--- a/arch/sparc64/kernel/iommu_common.h
+++ b/arch/sparc64/kernel/iommu_common.h
@@ -46,19 +46,6 @@ static inline unsigned long iommu_num_pages(unsigned long vaddr,
 	return npages;
 }
 
-static inline unsigned long calc_npages(struct scatterlist *sglist, int nelems)
-{
-	unsigned long i, npages = 0;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nelems, i) {
-		unsigned long paddr = SG_ENT_PHYS_ADDRESS(sg);
-		npages += iommu_num_pages(paddr, sg->length);
-	}
-
-	return npages;
-}
-
 static inline int is_span_boundary(unsigned long entry,
 				   unsigned long shift,
 				   unsigned long boundary_size,
-- 
1.5.3.6

