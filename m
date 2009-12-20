Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZLTRLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZLTRLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZLTRLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:11:35 -0500
Received: from mail.gmx.net ([213.165.64.20]:38584 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751901AbZLTRLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:11:33 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18q8vxmCcsqKkklHCkQvCVAai/VFH6TpX5kWJwBAb
	eyFZLtnWX8duTC
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/5] viafb: remove dead code
Date: Sun, 20 Dec 2009 17:16:46 +0000
Message-Id: <1261329409-3518-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1261329409-3518-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1261329409-3518-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove dead code

Remove a completly unused function.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/via_utility.c |   12 ------------
 drivers/video/via/via_utility.h |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/video/via/via_utility.c b/drivers/video/via/via_utility.c
index d53c3d5..aefdeee 100644
--- a/drivers/video/via/via_utility.c
+++ b/drivers/video/via/via_utility.c
@@ -239,15 +239,3 @@ void viafb_get_gamma_support_state(int bpp, unsigned int *support_state)
 	else
 		*support_state = CRT_Device | DVI_Device | LCD_Device;
 }
-
-int viafb_input_parameter_converter(int parameter_value)
-{
-	int result;
-
-	if (parameter_value >= 1 && parameter_value <= 9)
-		result = 1 << (parameter_value - 1);
-	else
-		result = 1;
-
-	return result;
-}
diff --git a/drivers/video/via/via_utility.h b/drivers/video/via/via_utility.h
index 2fd4552..1670ba8 100644
--- a/drivers/video/via/via_utility.h
+++ b/drivers/video/via/via_utility.h
@@ -30,6 +30,5 @@ bool viafb_lcd_get_support_expand_state(u32 xres, u32 yres);
 void viafb_set_gamma_table(int bpp, unsigned int *gamma_table);
 void viafb_get_gamma_table(unsigned int *gamma_table);
 void viafb_get_gamma_support_state(int bpp, unsigned int *support_state);
-int viafb_input_parameter_converter(int parameter_value);
 
 #endif /* __VIAUTILITY_H__ */
-- 
1.6.3.2

