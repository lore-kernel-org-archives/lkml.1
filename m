Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXG2PJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXG2PJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764766AbXG2O7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47857 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764762AbXG2O7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:32 -0400
Date: Sun, 29 Jul 2007 16:59:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] backlight: make 2 structs static
Message-ID: <20070729145909.GE16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global structs static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/video/backlight/backlight.c |    2 +-
 drivers/video/backlight/lcd.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1/drivers/video/backlight/backlight.c.old	2007-07-26 21:56:23.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/video/backlight/backlight.c	2007-07-26 21:56:31.000000000 +0200
@@ -164,7 +164,7 @@
 	return rc;
 }
 
-struct class *backlight_class;
+static struct class *backlight_class;
 
 static void bl_device_release(struct device *dev)
 {
--- linux-2.6.23-rc1-mm1/drivers/video/backlight/lcd.c.old	2007-07-26 21:57:40.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/video/backlight/lcd.c	2007-07-26 22:18:23.000000000 +0200
@@ -149,7 +149,7 @@
 	return sprintf(buf, "%d\n", ld->props.max_contrast);
 }
 
-struct class *lcd_class;
+static struct class *lcd_class;
 
 static void lcd_device_release(struct device *dev)
 {

