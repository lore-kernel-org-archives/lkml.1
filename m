Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253Ab0A1IMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0A1IMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676Ab0A1IMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:12:12 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:34299 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0A1IMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:12:10 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] tree-wide: trivial typo fixes: s/widht/width/g
Date: Thu, 28 Jan 2010 16:11:51 +0800
Message-Id: <1264666311-7284-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
---
 arch/m68k/include/asm/fbio.h  |    2 +-
 arch/sparc/include/asm/fbio.h |    2 +-
 drivers/net/skfp/ess.c        |    2 +-
 drivers/video/68328fb.c       |    2 +-
 drivers/video/pm2fb.c         |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/include/asm/fbio.h b/arch/m68k/include/asm/fbio.h
index b9215a0..0a21da8 100644
--- a/arch/m68k/include/asm/fbio.h
+++ b/arch/m68k/include/asm/fbio.h
@@ -173,7 +173,7 @@ struct mdi_cfginfo {
 	int     mdi_ncluts;     /* Number of implemented CLUTs in this MDI */
         int     mdi_type;       /* FBTYPE name */
         int     mdi_height;     /* height */
-        int     mdi_width;      /* widht */
+        int     mdi_width;      /* width */
         int     mdi_size;       /* available ram */
         int     mdi_mode;       /* 8bpp, 16bpp or 32bpp */
         int     mdi_pixfreq;    /* pixel clock (from PROM) */
diff --git a/arch/sparc/include/asm/fbio.h b/arch/sparc/include/asm/fbio.h
index b9215a0..0a21da8 100644
--- a/arch/sparc/include/asm/fbio.h
+++ b/arch/sparc/include/asm/fbio.h
@@ -173,7 +173,7 @@ struct mdi_cfginfo {
 	int     mdi_ncluts;     /* Number of implemented CLUTs in this MDI */
         int     mdi_type;       /* FBTYPE name */
         int     mdi_height;     /* height */
-        int     mdi_width;      /* widht */
+        int     mdi_width;      /* width */
         int     mdi_size;       /* available ram */
         int     mdi_mode;       /* 8bpp, 16bpp or 32bpp */
         int     mdi_pixfreq;    /* pixel clock (from PROM) */
diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
index a85efcf..e8387d2 100644
--- a/drivers/net/skfp/ess.c
+++ b/drivers/net/skfp/ess.c
@@ -557,7 +557,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 
 	/*
 	 * send never allocation request where the requested payload and
-	 * overhead is zero or deallocate bandwidht when no bandwidth is
+	 * overhead is zero or deallocate bandwidth when no bandwidth is
 	 * parsed
 	 */
 	if (!smc->mib.fddiESSPayload) {
diff --git a/drivers/video/68328fb.c b/drivers/video/68328fb.c
index 0b17824..2110556 100644
--- a/drivers/video/68328fb.c
+++ b/drivers/video/68328fb.c
@@ -308,7 +308,7 @@ static int mc68x328fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 	 * Pseudocolor:
 	 *    uses offset = 0 && length = RAMDAC register width.
 	 *    var->{color}.offset is 0
-	 *    var->{color}.length contains widht of DAC
+	 *    var->{color}.length contains width of DAC
 	 *    cmap is not used
 	 *    RAMDAC[X] is programmed to (red, green, blue)
 	 * Truecolor:
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
index 36436ee..27f93aa 100644
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -896,7 +896,7 @@ static int pm2fb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	 * Pseudocolor:
 	 *    uses offset = 0 && length = DAC register width.
 	 *    var->{color}.offset is 0
-	 *    var->{color}.length contains widht of DAC
+	 *    var->{color}.length contains width of DAC
 	 *    cmap is not used
 	 *    DAC[X] is programmed to (red, green, blue)
 	 * Truecolor:
-- 
1.6.3.3

