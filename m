Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXDZXrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXDZXrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXDZXrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:47:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35826 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753831AbXDZXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:47:15 -0400
Date: Fri, 27 Apr 2007 01:47:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Boichat <nicolas@boichat.ch>, Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make drivers/hwmon/applesmc.c:backlight_work static
Message-ID: <20070426234725.GD3468@stusta.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global "backlight_work" static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/hwmon/applesmc.c.old	2007-04-27 00:34:45.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/hwmon/applesmc.c	2007-04-27 00:34:57.000000000 +0200
@@ -742,7 +742,7 @@
 	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
 	mutex_unlock(&applesmc_lock);
 }
-DECLARE_WORK(backlight_work, &applesmc_backlight_set);
+static DECLARE_WORK(backlight_work, &applesmc_backlight_set);
 
 static void applesmc_brightness_set(struct led_classdev *led_cdev,
 						enum led_brightness value)

