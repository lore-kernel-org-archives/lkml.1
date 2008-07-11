Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbYGKPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbYGKPRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbYGKPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:09 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:5698 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbYGKPPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:05 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL0H-03-1OV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/16] AMD IOMMU: fix device table entry size
Date: Fri, 11 Jul 2008 17:14:34 +0200
Message-ID: <1215789275-20975-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0352 (UTC) FILETIME=[D4A18C00:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A device table entry is actually only 256 *bits* large. Not 256 bytes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/asm-x86/amd_iommu_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 14aaffe..2e8601b 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -27,7 +27,7 @@
 /*
  * some size calculation constants
  */
-#define DEV_TABLE_ENTRY_SIZE		256
+#define DEV_TABLE_ENTRY_SIZE		32
 #define ALIAS_TABLE_ENTRY_SIZE		2
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
-- 
1.5.3.7


