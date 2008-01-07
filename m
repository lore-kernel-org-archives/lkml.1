Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYAGBoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYAGBoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYAGBnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:43:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:13386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYAGBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="276215287"
Date: Mon, 7 Jan 2008 09:25:33 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][intel_agp] fix name for G35 chipset
Message-ID: <20080107012533.GA471@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	LKML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Change origin chipset name i965G_1 to market name G35.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d879619..7f8b06c 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -12,8 +12,8 @@
 
 #define PCI_DEVICE_ID_INTEL_82946GZ_HB      0x2970
 #define PCI_DEVICE_ID_INTEL_82946GZ_IG      0x2972
-#define PCI_DEVICE_ID_INTEL_82965G_1_HB     0x2980
-#define PCI_DEVICE_ID_INTEL_82965G_1_IG     0x2982
+#define PCI_DEVICE_ID_INTEL_82G35_HB        0x2980
+#define PCI_DEVICE_ID_INTEL_82G35_IG        0x2982
 #define PCI_DEVICE_ID_INTEL_82965Q_HB       0x2990
 #define PCI_DEVICE_ID_INTEL_82965Q_IG       0x2992
 #define PCI_DEVICE_ID_INTEL_82965G_HB       0x29A0
@@ -32,7 +32,7 @@
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82G35_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB || \
@@ -1866,7 +1866,7 @@ static const struct intel_driver_description {
 		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
 		NULL, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, 0, "965G",
+	{ PCI_DEVICE_ID_INTEL_82G35_HB, PCI_DEVICE_ID_INTEL_82G35_IG, 0, "G35",
 		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, 0, "965Q",
 		NULL, &intel_i965_driver },
@@ -2065,7 +2065,7 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_82945GM_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945GME_HB),
 	ID(PCI_DEVICE_ID_INTEL_82946GZ_HB),
-	ID(PCI_DEVICE_ID_INTEL_82965G_1_HB),
+	ID(PCI_DEVICE_ID_INTEL_82G35_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
-- 
1.5.3.4

