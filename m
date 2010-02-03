Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0BCFQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:16:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33986 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0BCFQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:16:49 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, Dinh.Nguyen@freescale.com,
       r.herring@freescale.com, bryan.wu@canonical.com
Subject: [PATCHv2 03/11] mxc: Fix Drive Strength Field in the IOMUX controller
Date: Tue,  2 Feb 2010 21:16:25 -0800
Message-Id: <ccc89dd7a6035abf5a78680404a2b30b9e025353.1265173480.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173246.git.amit.kucheria@verdurent.com>
 <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com>
 <9fa7a3c70c46a1f776c6520051481cff6525ef02.1265173480.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1265173480.git.amit.kucheria@canonical.com>
References: <cover.1265173480.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX51 defines 4 values:

00: Low Drive Strength
01: Medium Drive Strength
10: High Drive Strength
11: Max Drive Strength

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
index 1deda01..f2f73d3 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -81,11 +81,13 @@ struct pad_desc {
 
 #define PAD_CTL_ODE			(1 << 3)
 
-#define PAD_CTL_DSE_STANDARD		(0 << 1)
-#define PAD_CTL_DSE_HIGH		(1 << 1)
-#define PAD_CTL_DSE_MAX			(2 << 1)
+#define PAD_CTL_DSE_LOW			(0 << 1)
+#define PAD_CTL_DSE_MED			(1 << 1)
+#define PAD_CTL_DSE_HIGH		(2 << 1)
+#define PAD_CTL_DSE_MAX			(3 << 1)
 
 #define PAD_CTL_SRE_FAST		(1 << 0)
+#define PAD_CTL_SRE_SLOW		(0 << 0)
 
 /*
  * setups a single pad in the iomuxer
-- 
1.6.3.3

