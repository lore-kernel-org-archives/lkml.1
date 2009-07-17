Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbZGQAGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbZGQAGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933738AbZGQAGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39135 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933720AbZGQAGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 15/21] Blackfin: bf537-stamp: fix irq decl for AD7142
Date: Thu, 16 Jul 2009 20:05:40 -0400
Message-Id: <1247789146-18786-16-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

The AD7142 add-on card hooks the IRQ line up to PG5, not PF5.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index ab92e42..bd65690 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1313,7 +1313,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 #if defined(CONFIG_JOYSTICK_AD7142) || defined(CONFIG_JOYSTICK_AD7142_MODULE)
 	{
 		I2C_BOARD_INFO("ad7142_joystick", 0x2C),
-		.irq = IRQ_PF5,
+		.irq = IRQ_PG5,
 	},
 #endif
 #if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
-- 
1.6.3.3

