Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXIDK5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXIDK5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXIDK5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:57:13 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:53571 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbXIDK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:57:12 -0400
Date: Tue, 4 Sep 2007 12:58:31 +0200
From: aherrman@arcor.de
To: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] radeonfb: add PCI Id for RS482/Radeon Xpress 200M
Message-ID: <20070904105831.GE7320@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. which can be found in Acer Aspire 5100.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/video/aty/ati_ids.h     |    1 +
 drivers/video/aty/radeon_base.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/aty/ati_ids.h b/drivers/video/aty/ati_ids.h
index 685a754..648da1e 100644
--- a/drivers/video/aty/ati_ids.h
+++ b/drivers/video/aty/ati_ids.h
@@ -211,3 +211,4 @@
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
 #define PCI_CHIP_RS480_5955             0x5955
+#define PCI_CHIP_RS482_5975             0x5975
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 47ca62f..90a3957 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -102,6 +102,7 @@
 static struct pci_device_id radeonfb_pci_table[] = {
         /* Radeon Xpress 200m */
 	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RS482_5975,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility M6 */
 	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
-- 
1.5.3


