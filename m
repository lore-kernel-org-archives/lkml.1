Return-Path: <linux-kernel-owner+w=401wt.eu-S1763305AbYBWGRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763305AbYBWGRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYBWGPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:15:53 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:52365 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYBWGPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:15:49 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 4/4] alpha: remove unused DEBUG_FORCEDAC define in IOMMU
Date: Sat, 23 Feb 2008 15:13:15 +0900
Message-Id: <1203747195-7952-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1203747195-7952-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1203747195-7952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1203747195-7952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1203747195-7952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1203747195-7952-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just removes unused DEBUG_FORCEDAC define in the IOMMU code.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/kernel/pci_iommu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 54540c3..be6fa10 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -31,7 +31,6 @@
 #endif
 
 #define DEBUG_NODIRECT 0
-#define DEBUG_FORCEDAC 0
 
 #define ISA_DMA_MASK		0x00ffffff
 
-- 
1.5.3.4

