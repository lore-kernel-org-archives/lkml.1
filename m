Return-Path: <linux-kernel-owner+w=401wt.eu-S1762414AbYDVCRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414AbYDVCRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762017AbYDVCRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:17:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:47886 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761239AbYDVCRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,691,1199692800"; 
   d="scan'208";a="273112956"
Date: Tue, 22 Apr 2008 10:01:40 +0800
From: alek du <alek.du@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, jesse.barnes@intel.com
Subject: [PATCH 1/3] pci: Add Intel SCH PCI IDs
Message-ID: <20080422100140.71f947ca@dxy.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 02:17:03.0765 (UTC) FILETIME=[F479B450:01C8A41E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Intel SCH chipsets (US15W, US15L, UL11L) PCI IDs, these IDs
will be used by following SCH driver patches.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 include/linux/pci_ids.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 70eb3c8..b72b3b4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2413,6 +2413,20 @@
 #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
 #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
+#define PCI_DEVICE_ID_INTEL_SCH_HC	0x8100
+#define PCI_DEVICE_ID_INTEL_SCH_PE1	0x8110
+#define PCI_DEVICE_ID_INTEL_SCH_PE2	0x8112
+#define PCI_DEVICE_ID_INTEL_SCH_UC1	0x8114
+#define PCI_DEVICE_ID_INTEL_SCH_UC2	0x8115
+#define PCI_DEVICE_ID_INTEL_SCH_UC3	0x8116
+#define PCI_DEVICE_ID_INTEL_SCH_EC	0x8117
+#define PCI_DEVICE_ID_INTEL_SCH_UT	0x8118
+#define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
+#define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
+#define PCI_DEVICE_ID_INTEL_SCH_HDA	0x811b
+#define PCI_DEVICE_ID_INTEL_SCH_SD1	0x811c
+#define PCI_DEVICE_ID_INTEL_SCH_SD2	0x811d
+#define PCI_DEVICE_ID_INTEL_SCH_SD3	0x811e
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5
 #define PCI_DEVICE_ID_INTEL_82451NX	0x84ca
-- 
1.5.2.5
