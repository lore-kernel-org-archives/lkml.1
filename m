Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZLNA0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZLNA0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932102AbZLNA0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:26:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbZLMX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:29 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, akpm@linux-foundation.org,
       nicolas.ferre@atmel.com, hskinnemoen@atmel.com,
       rmk+kernel@arm.linux.org.uk, torvalds@linux-foundation.org
Subject: [PATCH 04/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:56 +0100
Message-Id: <a1f32826bdbcf3addf8457eb2c426cb3247fc3a9.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/video/atmel_lcdfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 3d886c6..22ee7f8 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -110,7 +110,7 @@ static int atmel_bl_get_brightness(struct backlight_device *bl)
 	return lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
 }
 
-static struct backlight_ops atmel_lcdc_bl_ops = {
+static const struct backlight_ops atmel_lcdc_bl_ops = {
 	.update_status = atmel_bl_update_status,
 	.get_brightness = atmel_bl_get_brightness,
 };
-- 
1.6.5.3

