Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbZIDGsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbZIDGsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932698AbZIDGsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:48:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:13395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932743AbZIDGps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:45:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,330,1249282800"; 
   d="scan'208";a="490450576"
Subject: [PATCH 15/18] ioat3: ioat3.2 pci ids for Jasper Forest
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com,
       Tom Picard <tom.s.picard@intel.com>
Date: Thu, 03 Sep 2009 23:45:51 -0700
Message-ID: <20090904064551.7141.2216.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Picard <tom.s.picard@intel.com>

Jasper Forest introduces raid offload support via ioat3.2 support.  When
raid offload is enabled two (out of 8 channels) will report raid5/raid6
offload capabilities.  The remaining channels will only report ioat3.0
capabilities (memcpy).

Signed-off-by: Tom Picard <tom.s.picard@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/pci.c  |   13 +++++++++++++
 include/linux/pci_ids.h |   10 ++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index b3d5e89..aad2fde 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -58,6 +58,19 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG5) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG6) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_TBG7) },
+
+	/* I/OAT v3.2 platforms */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF0) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF5) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF6) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF7) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF8) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF9) },
+
 	{ 0, }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0f71812..2b4b8ce 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2529,6 +2529,16 @@
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
 #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
 #define PCI_DEVICE_ID_INTEL_FBD_CNB	0x360c
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF0	0x3710
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF1	0x3711
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF2	0x3712
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF3	0x3713
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF4	0x3714
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF5	0x3715
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF6	0x3716
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF7	0x3717
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF8	0x3718
+#define PCI_DEVICE_ID_INTEL_IOAT_JSF9	0x3719
 #define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
 #define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
 #define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18

