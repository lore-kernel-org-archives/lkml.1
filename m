Return-Path: <linux-kernel-owner+w=401wt.eu-S965617AbXBTAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617AbXBTAOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbXBTAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:07:45 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36082 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965581AbXBTAH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:26 -0500
Date: Tue, 20 Feb 2007 01:07:25 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/misc/asus-laptop.c: make code static
Message-ID: <20070220000725.GT13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm1/drivers/misc/asus-laptop.c.old	2007-02-18 01:06:30.000000000 +0100
+++ linux-2.6.20-mm1/drivers/misc/asus-laptop.c	2007-02-18 01:06:43.000000000 +0100
@@ -211,7 +211,7 @@
 				     enum led_brightness value);	\
 	static void object##_led_update(struct work_struct *ignored);	\
 	static int object##_led_wk;					\
-	DECLARE_WORK(object##_led_work, object##_led_update);		\
+	static DECLARE_WORK(object##_led_work, object##_led_update);	\
 	static struct led_classdev object##_led = {			\
 		.name           = "asus:" ledname,			\
 		.brightness_set = object##_led_set,			\

