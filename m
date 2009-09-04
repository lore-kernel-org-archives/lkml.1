Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbZIDJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbZIDJtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933565AbZIDJtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:49:16 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:55467 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933572AbZIDJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:49:11 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXXR-01-4V9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] x86/amd-iommu: Remove redundant 'IOMMU' string
Date: Fri, 4 Sep 2009 11:47:26 +0200
Message-ID: <1252057647-32322-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
References: <1252057647-32322-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:47:29.0437 (UTC) FILETIME=[B792FCD0:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'IOMMU: ' prefix is not necessary because the
DUMP_printk macro already prints its own prefix.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 169958a..264b3ef 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -858,7 +858,7 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 		switch (*p) {
 		case ACPI_IVHD_TYPE:
 
-			DUMP_printk("IOMMU: device: %02x:%02x.%01x cap: %04x "
+			DUMP_printk("device: %02x:%02x.%01x cap: %04x "
 				    "seg: %d flags: %01x info %04x\n",
 				    PCI_BUS(h->devid), PCI_SLOT(h->devid),
 				    PCI_FUNC(h->devid), h->cap_ptr,
-- 
1.6.3.3


