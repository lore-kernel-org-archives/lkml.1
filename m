Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZCWPEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZCWPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZCWPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:04:24 -0400
Received: from mx1.emlix.com ([193.175.82.87]:52898 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZCWPEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:04:23 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 3/5] xtensa: add at24hc02b to s6105 platform
Date: Mon, 23 Mar 2009 16:05:16 +0100
Message-Id: <1237820718-30607-3-git-send-email-dg@emlix.com>
In-Reply-To: <1237820718-30607-1-git-send-email-dg@emlix.com>
References: <1237820718-30607-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is particularly used to read the MAC address of the ethernet
controller from an EEPROM.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 00f52ee..9394e6f 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -168,6 +168,9 @@ static struct resource s6_i2c_resource[] = {
 #define S6I2C_ADDR_PCA9543	0x73
 
 static struct i2c_board_info __initdata s6_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("24c02", S6I2C_ADDR_AT24HC02B),
+	},
 };
 
 static struct platform_device platform_devices[] = {
-- 
1.6.2.107.ge47ee

