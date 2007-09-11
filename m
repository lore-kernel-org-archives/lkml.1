Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXIKSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXIKSVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758302AbXIKSVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:21:12 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:59339 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757817AbXIKSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:21:11 -0400
Date: Tue, 11 Sep 2007 20:22:28 +0200
From: aherrman@arcor.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60
Message-ID: <20070911182228.GA5404@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO this is 2.6.23 material. Please apply.
Thanks a lot.


Regards,

Andreas

--
radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60.

As observed with various Radeon X300 cards console goes blank
without that fix.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/video/aty/radeon_base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 47ca62f..5a8af4d 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -1285,7 +1285,8 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
 	if (rinfo->family == CHIP_FAMILY_R300 ||
 	    rinfo->family == CHIP_FAMILY_RS300 ||
 	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	    rinfo->family == CHIP_FAMILY_RV350 ||
+	    rinfo->family == CHIP_FAMILY_RV380 ) {
 		if (mode->ppll_ref_div & R300_PPLL_REF_DIV_ACC_MASK) {
 			/* When restoring console mode, use saved PPLL_REF_DIV
 			 * setting.
-- 
1.5.1.6


