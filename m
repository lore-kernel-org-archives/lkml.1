Return-Path: <linux-kernel-owner+w=401wt.eu-S934366AbYEUBNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbYEUBNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935121AbYEUBNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:13:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934846AbYEUBNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:13:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] MODULE_LICENSE expects "GPL v2", not "GPLv2"
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JyctL-0000SA-TM@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:13:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 4235
Lines: 110

... and we have few enough places using the latter to make it
simpler to do search and replace...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sh/drivers/heartbeat.c               |    2 +-
 drivers/input/keyboard/aaed2000_kbd.c     |    2 +-
 drivers/input/keyboard/corgikbd.c         |    2 +-
 drivers/input/keyboard/jornada680_kbd.c   |    2 +-
 drivers/input/keyboard/jornada720_kbd.c   |    2 +-
 drivers/input/keyboard/spitzkbd.c         |    2 +-
 drivers/input/touchscreen/jornada720_ts.c |    2 +-
 drivers/scsi/mac_esp.c                    |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sh/drivers/heartbeat.c b/arch/sh/drivers/heartbeat.c
index ab77b0e..938817e 100644
--- a/arch/sh/drivers/heartbeat.c
+++ b/arch/sh/drivers/heartbeat.c
@@ -154,4 +154,4 @@ module_exit(heartbeat_exit);
 
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR("Paul Mundt");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/input/keyboard/aaed2000_kbd.c b/drivers/input/keyboard/aaed2000_kbd.c
index a293e8b..8a77bfc 100644
--- a/drivers/input/keyboard/aaed2000_kbd.c
+++ b/drivers/input/keyboard/aaed2000_kbd.c
@@ -183,4 +183,4 @@ module_exit(aaedkbd_exit);
 
 MODULE_AUTHOR("Nicolas Bellido Y Ortega");
 MODULE_DESCRIPTION("AAED-2000 Keyboard Driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/input/keyboard/corgikbd.c b/drivers/input/keyboard/corgikbd.c
index 29fbec6..1aa46ae 100644
--- a/drivers/input/keyboard/corgikbd.c
+++ b/drivers/input/keyboard/corgikbd.c
@@ -412,5 +412,5 @@ module_exit(corgikbd_exit);
 
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Corgi Keyboard Driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:corgi-keyboard");
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index 9387da3..781fc61 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -275,5 +275,5 @@ module_exit(jornada680kbd_exit);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 620/660/680/690 Keyboard Driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:jornada680_kbd");
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index a1164a0..ce650af 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -29,7 +29,7 @@
 
 MODULE_AUTHOR("Kristoffer Ericson <Kristoffer.Ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 710/720/728 keyboard driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 
 static unsigned short jornada_std_keymap[128] = {					/* ROW */
 	0, KEY_ESC, KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7,		/* #1  */
diff --git a/drivers/input/keyboard/spitzkbd.c b/drivers/input/keyboard/spitzkbd.c
index 61e401b..1aa3718 100644
--- a/drivers/input/keyboard/spitzkbd.c
+++ b/drivers/input/keyboard/spitzkbd.c
@@ -494,5 +494,5 @@ module_exit(spitzkbd_exit);
 
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Spitz Keyboard Driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:spitz-keyboard");
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 7422421..1aca108 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -24,7 +24,7 @@
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 710/720/728 touchscreen driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 
 struct jornada_ts {
 	struct input_dev *dev;
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index cd37bd6..887682a 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -650,7 +650,7 @@ static void __exit mac_esp_exit(void)
 
 MODULE_DESCRIPTION("Mac ESP SCSI driver");
 MODULE_AUTHOR("Finn Thain <fthain@telegraphics.com.au>");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 
 module_init(mac_esp_init);
-- 
1.5.3.GIT


