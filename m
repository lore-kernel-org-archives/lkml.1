Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZCZOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZCZOsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZCZOs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:48:27 -0400
Received: from mx1.emlix.com ([193.175.82.87]:52191 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975AbZCZOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:48:27 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 2/5] xtensa: add saa7121 to s6105 platform
Date: Thu, 26 Mar 2009 15:49:31 +0100
Message-Id: <1238078974-26040-2-git-send-email-dg@emlix.com>
In-Reply-To: <1238078974-26040-1-git-send-email-dg@emlix.com>
References: <1238078974-26040-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 9238d24..07fb329 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -202,6 +202,11 @@ static struct resource s6_i2c_resource[] = {
 #define S6I2C_ADDR_PCA9543	0x73
 
 static struct s6dp_link s6dp_links[] = {
+	{
+		.port_mask = 1 << 2,
+		.is_egress = 1,
+		.minor = 2,
+	},
 	{ }
 };
 
@@ -212,6 +217,10 @@ static struct i2c_board_info __initdata s6_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("m41t62", S6I2C_ADDR_M41T62),
 	},
+	{
+		I2C_BOARD_INFO("saa7121", S6I2C_ADDR_SAA7121),
+		.platform_data = &s6dp_links[0],
+	},
 };
 
 static struct resource s6_isef_resource[] = {
-- 
1.6.2.107.ge47ee

