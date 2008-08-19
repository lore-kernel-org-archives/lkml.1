Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYHRVHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYHRVHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYHRVHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:07:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:31581 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYHRVHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=wgtRBGUNrns4nZFvS2byOyfyzHtbDKYcuPvBn4uYPVWXNH5PuXfK5bZElda9XVs+pF
         GIUUDQpFd8xX6s9QL8C9BYekILFiH9jIv62bjecD8iN2Wx0OAecFHq/jEkCsqKiIY73r
         zRO69nXuk6vLrgnvuzVGZUHRPvbqd+ASNL+Xg=
Message-ID: <48AA3900.80305@gmail.com>
Date: Mon, 18 Aug 2008 23:07:44 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] RADEON: duplicate PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, is it correct?
---
duplicate PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index 675abda..74d2e65 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -210,7 +210,7 @@ static void radeon_pm_disable_dynamic_mode(struct radeonfb_info *rinfo)
 			 PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb	|
 			 PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb	|
 			 PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb		|
-			 PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb		|
+			 PIXCLKS_CNTL__R300_P2G2CLK_DAC_ALWAYS_ONb	|
 			 PIXCLKS_CNTL__R300_DISP_DAC_PIXCLK_DAC2_BLANK_OFF);
                 OUTPLL(pllPIXCLKS_CNTL, tmp);
 
@@ -392,7 +392,7 @@ static void radeon_pm_enable_dynamic_mode(struct radeonfb_info *rinfo)
 			PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb      |
 			PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb        |
 			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb           |
-			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb);
+			PIXCLKS_CNTL__R300_P2G2CLK_DAC_ALWAYS_ONb);
 		OUTPLL(pllPIXCLKS_CNTL, tmp);
 
 		tmp = INPLL(pllMCLK_MISC);
