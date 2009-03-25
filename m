Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZCYKyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZCYKyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZCYKyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:54:36 -0400
Received: from mx1.emlix.com ([193.175.82.87]:57907 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZCYKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:54:35 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 2/3] xtensa: add m41t62 rtc to s6105 platform
Date: Wed, 25 Mar 2009 11:55:36 +0100
Message-Id: <1237978537-23681-2-git-send-email-dg@emlix.com>
In-Reply-To: <1237978537-23681-1-git-send-email-dg@emlix.com>
References: <1237978537-23681-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index a55d054..bb59580 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -192,6 +192,9 @@ static struct i2c_board_info __initdata s6_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("24c02", S6I2C_ADDR_AT24HC02B),
 	},
+	{
+		I2C_BOARD_INFO("m41t62", S6I2C_ADDR_M41T62),
+	},
 };
 
 static struct resource s6_isef_resource[] = {
-- 
1.6.2.107.ge47ee

