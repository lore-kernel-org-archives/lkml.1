Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZGJBLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZGJBLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZGJBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:55346 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZGJBJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:10 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 15/15] x86: remove unused swiotlb_phys_to_bus() and swiotlb_bus_to_phys()
Date: Fri, 10 Jul 2009 10:05:04 +0900
Message-Id: <1247187904-31999-16-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:08:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phys_to_dma() and dma_to_phys() are used instead of
swiotlb_phys_to_bus() and swiotlb_bus_to_phys().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 165bd7f..e8a3501 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,16 +13,6 @@
 
 int swiotlb __read_mostly;
 
-dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-
-phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	return baddr;
-}
-
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
-- 
1.6.0.6

