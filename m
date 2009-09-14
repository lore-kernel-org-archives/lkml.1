Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbZINUIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbZINUIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZINUIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54084 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933557AbZINUIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 34/72] Blackfin: clean up duplicate I2C device type definitions
Date: Mon, 14 Sep 2009 16:07:38 -0400
Message-Id: <1252958896-25150-35-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

I2C_BOARD_INFO() already sets .type, no need to set it again.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 3a62066..85f9ac5 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -796,13 +796,11 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 #if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
-		.type = "pcf8574_lcd",
 	},
 #endif
 #if defined(CONFIG_INPUT_PCF8574) || defined(CONFIG_INPUT_PCF8574_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
-		.type = "pcf8574_keypad",
 		.irq = IRQ_PF8,
 	},
 #endif
-- 
1.6.4.2

