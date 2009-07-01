Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZGASMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZGASMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZGASMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:12:24 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31697 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZGASMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:12:23 -0400
X-IronPort-AV: E=Sophos;i="4.42,326,1243814400"; 
   d="scan'208";a="335646055"
From: Roland Dreier <rdreier@cisco.com>
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] I/OAT: Convert to PCI_VDEVICE()
Date: Wed, 01 Jul 2009 11:12:25 -0700
Message-ID: <adaprckff1y.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2009 18:12:26.0164 (UTC) FILETIME=[7CFAE740:01C9FA77]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup to make the PCI ID table easier to read.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/dma/ioat.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index 2225bb6..78072c5 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -40,23 +40,23 @@ MODULE_AUTHOR("Intel Corporation");
 
 static struct pci_device_id ioat_pci_tbl[] = {
 	/* I/OAT v1 platforms */
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
+	{ PCI_VDEVICE(UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
 
 	/* I/OAT v2 platforms */
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB) },
 
 	/* I/OAT v3 platforms */
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG1) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG2) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG3) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG4) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG5) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG6) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG7) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG0) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG1) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG3) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG4) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG5) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG6) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG7) },
 	{ 0, }
 };
 
