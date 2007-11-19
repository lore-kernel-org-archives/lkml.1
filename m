Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbXKSI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbXKSI2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbXKSI21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:28:27 -0500
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:39923 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbXKSI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:28:26 -0500
Date: Mon, 19 Nov 2007 09:28:22 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] radeonfb: add chip definition for RV370 5b63
Message-ID: <20071119082822.GA5118@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just a tiny patch to enable radeonfb for another Radeon card.
It was acked by Benjamin, see
http://marc.info/?l=linux-fbdev-devel&m=119516950701198&w=2


Regards,

Andreas
--
radeonfb: add chip definition for RV370 5b63

... which I've found on a Sapphire X550 (Silent).

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/video/aty/radeon_base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 1e32b3d..62867cb 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -202,6 +202,7 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	CHIP_DEF(PCI_CHIP_RV380_3154,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RV370_5B60,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5B62,	RV380,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV370_5B63,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5B64,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5B65,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5460,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
-- 
1.5.3.4


