Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbYDUNXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbYDUNXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759934AbYDUNTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:5375 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759701AbYDUNSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=G19MMrU71i1fGFYQEQzR7aZBvQZpZBlDaNXrC/pTp2aT8XxLfR2U/3GsUfDaggdy4xxmmJufhudJlHxBhGwX/ZmYn1zzcsJyoATeGdWl/4752hLOcq/HQbSfPRWM5YO2WnKcCBzFw2xzMjxTveYshAkjJSb2jgyXTWv87e9Z2ts=
Message-Id: <bf8cb3141884138c2e4a2ecb56300ece6e8020a2.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:19:10 -0400
Subject: [PATCH 17/37] Input: xpad - drop obsolete driver versioning
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver version numbers and changelog have not been updated in a
long while to reflect actual changes. Remove the version number and
add a notice that later changes can be tracked in SCM.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index fd80113..7188eec 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -1,5 +1,5 @@
 /*
- * X-Box gamepad - v0.0.6
+ * X-Box gamepad driver
  *
  * Copyright (c) 2002 Marko Friedemann <mfr@bmx-chemnitz.de>
  *               2004 Oliver Schwartz <Oliver.Schwartz@gmx.de>,
@@ -68,6 +68,8 @@
  *  - dance pads will map D-PAD to buttons, not axes
  *  - pass the module paramater 'dpad_to_buttons' to force
  *    the D-PAD to map to buttons if your pad is not detected
+ *
+ * Later changes can be tracked in SCM.
  */
 
 #include <linux/kernel.h>
@@ -77,7 +79,6 @@
 #include <linux/module.h>
 #include <linux/usb/input.h>
 
-#define DRIVER_VERSION "v0.0.6"
 #define DRIVER_AUTHOR "Marko Friedemann <mfr@bmx-chemnitz.de>"
 #define DRIVER_DESC "X-Box pad driver"
 
@@ -771,7 +772,7 @@ static int __init usb_xpad_init(void)
 {
 	int result = usb_register(&xpad_driver);
 	if (result == 0)
-		info(DRIVER_DESC ":" DRIVER_VERSION);
+		info(DRIVER_DESC);
 	return result;
 }
 
-- 
1.5.5.rc2.6.gf58d


