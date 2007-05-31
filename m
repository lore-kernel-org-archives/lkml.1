Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXEaDvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXEaDvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXEaDvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:51:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:39510 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbXEaDvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:51:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,596,1170662400"; 
   d="scan'208";a="251512923"
Date: Thu, 31 May 2007 11:51:12 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Subject: [AGPGART] intel_agp: add support for 945GME
Message-ID: <20070531035112.GC25433@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
References: <20070531033406.GB25433@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531033406.GB25433@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[AGPGART] intel_agp: add support for 945GME

Add pci id info for 945GME.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 5c1bffe..3c4a1c2 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -21,6 +21,7 @@
 #define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
 #define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
+#define PCI_DEVICE_ID_INTEL_82945GME_IG     0x27AE
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
@@ -1782,6 +1783,8 @@ static const struct intel_driver_description {
 		&intel_845_driver, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, "945GM",
 		&intel_845_driver, &intel_915_driver },
+	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, "945GME",
+		&intel_845_driver, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, "946GZ",
 		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, "965G",
-- 
1.4.4.4
