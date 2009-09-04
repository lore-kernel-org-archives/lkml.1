Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbZIDJto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbZIDJto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbZIDJtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:49:14 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56757 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbZIDJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:49:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KPFXXQ-01-4V7-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] x86/amd-iommu: Remove some merge helper code
Date: Fri, 4 Sep 2009 11:47:24 +0200
Message-ID: <1252057647-32322-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
References: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:47:29.0406 (UTC) FILETIME=[B78E41E0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some left-overs which where put into the code to
simplify merging code which also depends on changes in other trees.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6c99f50..70fdef5 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -41,9 +41,7 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
-#ifdef CONFIG_IOMMU_API
 static struct iommu_ops amd_iommu_ops;
-#endif
 
 /*
  * general struct to manage commands send to an IOMMU
@@ -62,10 +60,6 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
 
-#ifndef BUS_NOTIFY_UNBOUND_DRIVER
-#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
-#endif
-
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
-- 
1.6.3.3


