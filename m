Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYIXNlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYIXNlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYIXNlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:41:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:59514 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYIXNlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:41:24 -0400
Date: Wed, 24 Sep 2008 22:41:10 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: [PATCH] x86 gart: remove unnecessary initialization
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080924224038N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against tip/x86/iommu

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86 gart: remove unnecessary initialization in struct dma_mapping_ops

There is no point to have such initialization in struct dma_mapping_ops.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 25c94fb..b85a2f9 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -715,12 +715,6 @@ extern int agp_amd64_init(void);
 static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
 	.unmap_single			= gart_unmap_single,
-	.sync_single_for_cpu		= NULL,
-	.sync_single_for_device		= NULL,
-	.sync_single_range_for_cpu	= NULL,
-	.sync_single_range_for_device	= NULL,
-	.sync_sg_for_cpu		= NULL,
-	.sync_sg_for_device		= NULL,
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.alloc_coherent			= gart_alloc_coherent,
-- 
1.5.6.5

