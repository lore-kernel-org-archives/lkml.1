Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZLFOeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZLFOeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbZLFOeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:34:14 -0500
Received: from mail.is74.ru ([83.142.161.14]:55070 "EHLO relay.intersvyaz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZLFOeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:34:13 -0500
Message-ID: <4B1BC0E7.1010403@chelcom.ru>
Date: Sun, 06 Dec 2009 19:34:15 +0500
From: "A. Porodko" <panda@chelcom.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       Andrey Porodko <panda@chelcom.ru>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Patch for MSP430 and SOC audio support for Neuros OSD2 platform code.
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please, consider this patch for Neuros OSD2 platform code. Particular
drivers code have been
sent to consideration of respective maintainers.
Thank you.
--------------------------------------------------------------------------
>From e5aef120a1a4af6b678b8ffe6d9be1d065cb305e Mon Sep 17 00:00:00 2001
From: Andrey Porodko <panda@chelcom.ru>
Date: Sat, 5 Dec 2009 15:54:42 +0500
Subject: [PATCH] Neuros OSD2 board platform code patch for supporting msp430
 microcontroller and sound soc.

Signed-off-by: Andrey Porodko <panda@chelcom.ru>
---
 arch/arm/mach-davinci/board-neuros-osd2.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c
b/arch/arm/mach-davinci/board-neuros-osd2.c
index bd9ca07..28b3d67 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -202,6 +202,12 @@ static struct davinci_i2c_platform_data
ntosd2_i2c_pdata = {
 };
 
 static struct i2c_board_info __initdata ntosd2_i2c_info[] =  {
+    {                    /* MSP430 interface    */
+        I2C_BOARD_INFO("davinci_msp", NTOSD2_MSP430_I2C_ADDR),
+    },
+    {
+        I2C_BOARD_INFO("tlv320aic3x", NTOSD2_AUDIOSOC_I2C_ADDR),
+    },
 };
 
 static    int ntosd2_init_i2c(void)
-- 
1.5.6.5


-- 
Best regards
Andrey A. Porodko
 

