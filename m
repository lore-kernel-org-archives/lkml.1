Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbZIDGqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbZIDGqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932924AbZIDGqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:46:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:41977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbZIDGqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:46:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,330,1249282800"; 
   d="scan'208";a="490450617"
Subject: [PATCH 18/18] I/OAT: Convert to PCI_VDEVICE()
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
       maciej.sosnowski@intel.com
Date: Thu, 03 Sep 2009 23:46:06 -0700
Message-ID: <20090904064606.7141.40657.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>

Trivial cleanup to make the PCI ID table easier to read.

[dan.j.williams@intel.com: extended to v3.2 devices]
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/pci.c |   46 +++++++++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 8d96533..c788fa2 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -41,35 +41,35 @@ MODULE_AUTHOR("Intel Corporation");
 
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
 
 	/* I/OAT v3.2 platforms */
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF0) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF1) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF2) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF3) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF4) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF5) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF6) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF7) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF8) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF9) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF0) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF1) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF3) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF4) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF5) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF6) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF7) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF8) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF9) },
 
 	{ 0, }
 };

