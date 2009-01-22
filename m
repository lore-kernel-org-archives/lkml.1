Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZAVHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZAVHgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 02:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZAVHgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 02:36:11 -0500
Received: from cathcart.site5.com ([74.54.107.137]:45668 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZAVHgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 02:36:10 -0500
Message-ID: <497821E3.8080308@compulab.co.il>
Date: Thu, 22 Jan 2009 09:36:03 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: LKML <linux-kernel@vger.kernel.org>, eric miao <eric.miao@marvell.com>
Subject: [RESEND] [PATCH] drivers/video/backlight: rename da903x to da903x_bl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently both da903x backlight and voltage reulator drivers have the
same name. Rename the backlight driver to allow use of both drivers as
modules.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Eric Miao <eric.miao@marvell.com>

---
 drivers/video/backlight/Makefile                  |    2 +-
 drivers/video/backlight/{da903x.c => da903x_bl.c} |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/video/backlight/{da903x.c => da903x_bl.c} (100%)

diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 103427d..2d8f7cb 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
-obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x.o
+obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
diff --git a/drivers/video/backlight/da903x.c b/drivers/video/backlight/da903x_bl.c
similarity index 100%
rename from drivers/video/backlight/da903x.c
rename to drivers/video/backlight/da903x_bl.c
-- 
1.5.6.4


-- 
Sincerely yours,
Mike.

