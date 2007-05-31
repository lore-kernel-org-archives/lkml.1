Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbXEaDeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbXEaDeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759736AbXEaDe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:34:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:30194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759719AbXEaDe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,596,1170662400"; 
   d="scan'208";a="251509112"
Date: Thu, 31 May 2007 11:34:06 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Subject: [AGPGART] intel_agp: add support for 965GME/GLE
Message-ID: <20070531033406.GB25433@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dave,

Here's the patch to add pci ids for 965GME/GLE chip. It is
based on latest git and with these two applied. 
+ intel_agp-cleanup-intel-private-data.patch
+ intel_agp-use-table-for-device-probe.patch

Add pci id info for 965GME/GLE support.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index dcb6d4f..5c1bffe 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -20,6 +20,7 @@
 #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
 #define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
+#define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
@@ -1791,6 +1792,8 @@ static const struct intel_driver_description {
 		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, "965GM",
 		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, "965GME/GLE",
+		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
 	{ 0, 0, NULL, NULL, NULL }
-- 
1.4.4.4
