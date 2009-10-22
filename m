Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZJVHTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZJVHTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZJVHTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:19:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38023 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZJVHT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:19:28 -0400
Date: Thu, 22 Oct 2009 09:19:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-mmc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: msm_sdcc.c: remove references to htc_pwrsink
Message-ID: <20091022071926.GA3244@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


htc_pwrsing code never went to mainline, remove references to it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index dba4600..64d4e48 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -41,7 +41,6 @@
 #include <asm/mach/mmc.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
-#include <mach/htc_pwrsink.h>
 
 #include "msm_sdcc.h"
 
@@ -775,13 +774,11 @@ msmsdcc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		htc_pwrsink_set(PWRSINK_SDCARD, 0);
 		break;
 	case MMC_POWER_UP:
 		pwr |= MCI_PWR_UP;
 		break;
 	case MMC_POWER_ON:
-		htc_pwrsink_set(PWRSINK_SDCARD, 100);
 		pwr |= MCI_PWR_ON;
 		break;
 	}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
