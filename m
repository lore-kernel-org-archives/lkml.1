Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXHZJMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXHZJMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 05:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXHZJMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 05:12:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35108 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXHZJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 05:12:35 -0400
Date: Sun, 26 Aug 2007 11:12:37 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] atyfb: remove dead code
Message-ID: <20070826091237.GA17667@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/video/aty/atyfb_base.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2767,8 +2767,7 @@ static int atyfb_blank(int blank, struct
 	if (par->lock_blank || par->asleep)
 		return 0;
 
-#ifdef CONFIG_FB_ATY_BACKLIGHT
-#elif defined(CONFIG_FB_ATY_GENERIC_LCD)
+#ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table && blank > FB_BLANK_NORMAL &&
 	    (aty_ld_lcd(LCD_GEN_CNTL, par) & LCD_ON)) {
 		u32 pm = aty_ld_lcd(POWER_MANAGEMENT, par);
@@ -2797,8 +2796,7 @@ static int atyfb_blank(int blank, struct
 	}
 	aty_st_le32(CRTC_GEN_CNTL, gen_cntl, par);
 
-#ifdef CONFIG_FB_ATY_BACKLIGHT
-#elif defined(CONFIG_FB_ATY_GENERIC_LCD)
+#ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table && blank <= FB_BLANK_NORMAL &&
 	    (aty_ld_lcd(LCD_GEN_CNTL, par) & LCD_ON)) {
 		u32 pm = aty_ld_lcd(POWER_MANAGEMENT, par);
