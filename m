Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYJXFma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYJXFma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYJXFmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:42:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:45196 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbYJXFmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:42:11 -0400
Date: Fri, 24 Oct 2008 14:41:03 +0900
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net, jens.axboe@oracle.com
Subject: [PATCH] alpha: remove dead BIO_VMERGE_BOUNDARY definition
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024143850M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block layer dropped the virtual merge feature
(b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
definition is meaningless now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/include/asm/io.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index e971ab0..eda9b90 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -96,9 +96,6 @@ static inline dma_addr_t __deprecated isa_page_to_bus(struct page *page)
 	return page_to_phys(page);
 }
 
-/* This depends on working iommu.  */
-#define BIO_VMERGE_BOUNDARY	(alpha_mv.mv_pci_tbi ? PAGE_SIZE : 0)
-
 /* Maximum PIO space address supported?  */
 #define IO_SPACE_LIMIT 0xffff
 
-- 
1.5.4.2

