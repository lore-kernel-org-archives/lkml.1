Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbYESWJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbYESWJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbYESWGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:06:19 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40198 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765130AbYESWGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:06:16 -0400
Date: Tue, 20 May 2008 01:04:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] input: remove CVS keywords
Message-ID: <20080519220409.GJ17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/input/gameport-programming.txt   |    2 --
 Documentation/input/input.txt                  |    1 -
 Documentation/input/joystick-api.txt           |    2 --
 Documentation/input/joystick-parport.txt       |    1 -
 Documentation/input/joystick.txt               |    1 -
 drivers/input/evbug.c                          |    2 --
 drivers/input/gameport/emu10k1-gp.c            |    2 --
 drivers/input/gameport/lightning.c             |    2 --
 drivers/input/gameport/ns558.c                 |    2 --
 drivers/input/joystick/a3d.c                   |    2 --
 drivers/input/joystick/amijoy.c                |    2 --
 drivers/input/joystick/cobra.c                 |    2 --
 drivers/input/joystick/db9.c                   |    2 --
 drivers/input/joystick/gf2k.c                  |    2 --
 drivers/input/joystick/grip.c                  |    2 --
 drivers/input/joystick/grip_mp.c               |    2 --
 drivers/input/joystick/guillemot.c             |    2 --
 drivers/input/joystick/iforce/iforce-ff.c      |    2 --
 drivers/input/joystick/iforce/iforce-main.c    |    2 --
 drivers/input/joystick/iforce/iforce-packets.c |    2 --
 drivers/input/joystick/iforce/iforce-serio.c   |    2 --
 drivers/input/joystick/iforce/iforce-usb.c     |    2 --
 drivers/input/joystick/iforce/iforce.h         |    2 --
 drivers/input/joystick/interact.c              |    2 --
 drivers/input/joystick/joydump.c               |    2 --
 drivers/input/joystick/magellan.c              |    2 --
 drivers/input/joystick/spaceball.c             |    2 --
 drivers/input/joystick/spaceorb.c              |    2 --
 drivers/input/joystick/stinger.c               |    2 --
 drivers/input/joystick/tmdc.c                  |    2 --
 drivers/input/joystick/turbografx.c            |    2 --
 drivers/input/joystick/twidjoy.c               |    4 ----
 drivers/input/joystick/warrior.c               |    2 --
 drivers/input/keyboard/amikbd.c                |    2 --
 drivers/input/keyboard/sunkbd.c                |    2 --
 drivers/input/keyboard/xtkbd.c                 |    2 --
 drivers/input/mouse/inport.c                   |    2 --
 drivers/input/mouse/logibm.c                   |    2 --
 drivers/input/mouse/pc110pad.c                 |    2 --
 drivers/input/mouse/sermouse.c                 |    2 --
 drivers/input/serio/ct82c710.c                 |    2 --
 drivers/input/serio/q40kbd.c                   |    2 --
 drivers/input/serio/rpckbd.c                   |    2 --
 drivers/input/touchscreen/gunze.c              |    2 --
 drivers/input/touchscreen/h3600_ts_input.c     |    2 --
 include/linux/joystick.h                       |    2 --
 46 files changed, 91 deletions(-)

f48bb31b84b42b1de3148da376032763f50cd2f1 diff --git a/Documentation/input/gameport-programming.txt b/Documentation/input/gameport-programming.txt
index 14e0a8b..03a74fc 100644
--- a/Documentation/input/gameport-programming.txt
+++ b/Documentation/input/gameport-programming.txt
@@ -1,5 +1,3 @@
-$Id: gameport-programming.txt,v 1.3 2001/04/24 13:51:37 vojtech Exp $
-
 Programming gameport drivers
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/Documentation/input/input.txt b/Documentation/input/input.txt
index ff8cea0..686ee99 100644
--- a/Documentation/input/input.txt
+++ b/Documentation/input/input.txt
@@ -1,7 +1,6 @@
 			  Linux Input drivers v1.0
 	       (c) 1999-2001 Vojtech Pavlik <vojtech@ucw.cz>
 			     Sponsored by SuSE
-	    $Id: input.txt,v 1.8 2002/05/29 03:15:01 bradleym Exp $
 ----------------------------------------------------------------------------
 
 0. Disclaimer
diff --git a/Documentation/input/joystick-api.txt b/Documentation/input/joystick-api.txt
index acbd32b..c507330 100644
--- a/Documentation/input/joystick-api.txt
+++ b/Documentation/input/joystick-api.txt
@@ -5,8 +5,6 @@
 
 			      7 Aug 1998
 
-	$Id: joystick-api.txt,v 1.2 2001/05/08 21:21:23 vojtech Exp $
-
 1. Initialization
 ~~~~~~~~~~~~~~~~~
 
diff --git a/Documentation/input/joystick-parport.txt b/Documentation/input/joystick-parport.txt
index ede5f33..1c856f3 100644
--- a/Documentation/input/joystick-parport.txt
+++ b/Documentation/input/joystick-parport.txt
@@ -2,7 +2,6 @@
 	       (c) 1998-2000 Vojtech Pavlik <vojtech@ucw.cz>
 	       (c) 1998 Andree Borrmann <a.borrmann@tu-bs.de>
 			     Sponsored by SuSE
-	$Id: joystick-parport.txt,v 1.6 2001/09/25 09:31:32 vojtech Exp $
 ----------------------------------------------------------------------------
 
 0. Disclaimer
diff --git a/Documentation/input/joystick.txt b/Documentation/input/joystick.txt
index 389de9b..154d767 100644
--- a/Documentation/input/joystick.txt
+++ b/Documentation/input/joystick.txt
@@ -1,7 +1,6 @@
 		       Linux Joystick driver v2.0.0
 	       (c) 1996-2000 Vojtech Pavlik <vojtech@ucw.cz>
 			     Sponsored by SuSE
-	   $Id: joystick.txt,v 1.12 2002/03/03 12:13:07 jdeneux Exp $
 ----------------------------------------------------------------------------
 
 0. Disclaimer
diff --git a/drivers/input/evbug.c b/drivers/input/evbug.c
index c21f2f1..67754c7 100644
--- a/drivers/input/evbug.c
+++ b/drivers/input/evbug.c
@@ -1,6 +1,4 @@
 /*
- * $Id: evbug.c,v 1.10 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
index 9793ac3..b04930f 100644
--- a/drivers/input/gameport/emu10k1-gp.c
+++ b/drivers/input/gameport/emu10k1-gp.c
@@ -1,6 +1,4 @@
 /*
- * $Id: emu10k1-gp.c,v 1.8 2002/01/22 20:40:46 vojtech Exp $
- *
  *  Copyright (c) 2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/gameport/lightning.c b/drivers/input/gameport/lightning.c
index 6b4d456..06ad36e 100644
--- a/drivers/input/gameport/lightning.c
+++ b/drivers/input/gameport/lightning.c
@@ -1,6 +1,4 @@
 /*
- * $Id: lightning.c,v 1.20 2002/01/22 20:41:31 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/gameport/ns558.c b/drivers/input/gameport/ns558.c
index 7b7a546..2b282cd 100644
--- a/drivers/input/gameport/ns558.c
+++ b/drivers/input/gameport/ns558.c
@@ -1,6 +1,4 @@
 /*
- * $Id: ns558.c,v 1.43 2002/01/24 19:23:21 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *  Copyright (c) 1999 Brian Gerst
  */
diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 52ba16f..92498d4 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -1,6 +1,4 @@
 /*
- * $Id: a3d.c,v 1.21 2002/01/22 20:11:50 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index deb9f82..05022f0 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -1,6 +1,4 @@
 /*
- * $Id: amijoy.c,v 1.13 2002/01/22 20:26:32 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/cobra.c b/drivers/input/joystick/cobra.c
index 55646a6..639b975 100644
--- a/drivers/input/joystick/cobra.c
+++ b/drivers/input/joystick/cobra.c
@@ -1,6 +1,4 @@
 /*
- * $Id: cobra.c,v 1.19 2002/01/22 20:26:52 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/db9.c b/drivers/input/joystick/db9.c
index 960e501..5239594 100644
--- a/drivers/input/joystick/db9.c
+++ b/drivers/input/joystick/db9.c
@@ -1,6 +1,4 @@
 /*
- * $Id: db9.c,v 1.13 2002/04/07 20:13:37 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 1f6302c..cb6eef1 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -1,6 +1,4 @@
 /*
- * $Id: gf2k.c,v 1.19 2002/01/22 20:27:43 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/grip.c b/drivers/input/joystick/grip.c
index fd3853a..684e07c 100644
--- a/drivers/input/joystick/grip.c
+++ b/drivers/input/joystick/grip.c
@@ -1,6 +1,4 @@
 /*
- * $Id: grip.c,v 1.21 2002/01/22 20:27:57 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/grip_mp.c b/drivers/input/joystick/grip_mp.c
index c57e21d..8279481 100644
--- a/drivers/input/joystick/grip_mp.c
+++ b/drivers/input/joystick/grip_mp.c
@@ -1,6 +1,4 @@
 /*
- * $Id: grip_mp.c,v 1.9 2002/07/20 19:28:45 bonnland Exp $
- *
  *  Driver for the Gravis Grip Multiport, a gamepad "hub" that
  *  connects up to four 9-pin digital gamepads/joysticks.
  *  Driver tested on SMP and UP kernel versions 2.4.18-4 and 2.4.18-5.
diff --git a/drivers/input/joystick/guillemot.c b/drivers/input/joystick/guillemot.c
index aa6bfb3..25ec3fa 100644
--- a/drivers/input/joystick/guillemot.c
+++ b/drivers/input/joystick/guillemot.c
@@ -1,6 +1,4 @@
 /*
- * $Id: guillemot.c,v 1.10 2002/01/22 20:28:12 vojtech Exp $
- *
  *  Copyright (c) 2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/iforce/iforce-ff.c b/drivers/input/joystick/iforce/iforce-ff.c
index f2a4381..7839b7b 100644
--- a/drivers/input/joystick/iforce/iforce-ff.c
+++ b/drivers/input/joystick/iforce/iforce-ff.c
@@ -1,6 +1,4 @@
 /*
- * $Id: iforce-ff.c,v 1.9 2002/02/02 19:28:35 jdeneux Exp $
- *
  *  Copyright (c) 2000-2002 Vojtech Pavlik <vojtech@ucw.cz>
  *  Copyright (c) 2001-2002, 2007 Johann Deneux <johann.deneux@gmail.com>
  *
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index a2517fa..61ee6e3 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -1,6 +1,4 @@
 /*
- * $Id: iforce-main.c,v 1.19 2002/07/07 10:22:50 jdeneux Exp $
- *
  *  Copyright (c) 2000-2002 Vojtech Pavlik <vojtech@ucw.cz>
  *  Copyright (c) 2001-2002, 2007 Johann Deneux <johann.deneux@gmail.com>
  *
diff --git a/drivers/input/joystick/iforce/iforce-packets.c b/drivers/input/joystick/iforce/iforce-packets.c
index 45c4939..015b50a 100644
--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -1,6 +1,4 @@
 /*
- * $Id: iforce-packets.c,v 1.16 2002/07/07 10:22:50 jdeneux Exp $
- *
  *  Copyright (c) 2000-2002 Vojtech Pavlik <vojtech@ucw.cz>
  *  Copyright (c) 2001-2002, 2007 Johann Deneux <johann.deneux@gmail.com>
  *
diff --git a/drivers/input/joystick/iforce/iforce-serio.c b/drivers/input/joystick/iforce/iforce-serio.c
index 7b4bc19..46d5041 100644
--- a/drivers/input/joystick/iforce/iforce-serio.c
+++ b/drivers/input/joystick/iforce/iforce-serio.c
@@ -1,6 +1,4 @@
 /*
- * $Id: iforce-serio.c,v 1.4 2002/01/28 22:45:00 jdeneux Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik <vojtech@ucw.cz>
  *  Copyright (c) 2001, 2007 Johann Deneux <johann.deneux@gmail.com>
  *
diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index 7fb3cf8..c626758 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -1,6 +1,4 @@
  /*
- * $Id: iforce-usb.c,v 1.16 2002/06/09 11:08:04 jdeneux Exp $
- *
  *  Copyright (c) 2000-2002 Vojtech Pavlik <vojtech@ucw.cz>
  *  Copyright (c) 2001-2002, 2007 Johann Deneux <johann.deneux@gmail.com>
  *
diff --git a/drivers/input/joystick/iforce/iforce.h b/drivers/input/joystick/iforce/iforce.h
index a964a7c..f2d91f4 100644
--- a/drivers/input/joystick/iforce/iforce.h
+++ b/drivers/input/joystick/iforce/iforce.h
@@ -1,6 +1,4 @@
 /*
- * $Id: iforce.h,v 1.13 2002/07/07 10:22:50 jdeneux Exp $
- *
  *  Copyright (c) 2000-2002 Vojtech Pavlik <vojtech@ucw.cz>
  *  Copyright (c) 2001-2002, 2007 Johann Deneux <johann.deneux@gmail.com>
  *
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index bc8ea95..8c3290b 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -1,6 +1,4 @@
 /*
- * $Id: interact.c,v 1.16 2002/01/22 20:28:25 vojtech Exp $
- *
  *  Copyright (c) 2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/joystick/joydump.c b/drivers/input/joystick/joydump.c
index 88ec5a9..2a1b82c 100644
--- a/drivers/input/joystick/joydump.c
+++ b/drivers/input/joystick/joydump.c
@@ -1,6 +1,4 @@
 /*
- * $Id: joydump.c,v 1.1 2002/01/23 06:56:16 jsimmons Exp $
- *
  *  Copyright (c) 1996-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/magellan.c b/drivers/input/joystick/magellan.c
index 54e6769..40e4078 100644
--- a/drivers/input/joystick/magellan.c
+++ b/drivers/input/joystick/magellan.c
@@ -1,6 +1,4 @@
 /*
- * $Id: magellan.c,v 1.16 2002/01/22 20:28:39 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/joystick/spaceball.c b/drivers/input/joystick/spaceball.c
index d4087fd..0cd9b29 100644
--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -1,6 +1,4 @@
 /*
- * $Id: spaceball.c,v 1.17 2002/01/22 20:29:03 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/joystick/spaceorb.c b/drivers/input/joystick/spaceorb.c
index f7ce400..a694bf8 100644
--- a/drivers/input/joystick/spaceorb.c
+++ b/drivers/input/joystick/spaceorb.c
@@ -1,6 +1,4 @@
 /*
- * $Id: spaceorb.c,v 1.15 2002/01/22 20:29:19 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/joystick/stinger.c b/drivers/input/joystick/stinger.c
index baa10b2..e0db9f5 100644
--- a/drivers/input/joystick/stinger.c
+++ b/drivers/input/joystick/stinger.c
@@ -1,6 +1,4 @@
 /*
- * $Id: stinger.c,v 1.10 2002/01/22 20:29:31 vojtech Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *  Copyright (c) 2000 Mark Fletcher
  */
diff --git a/drivers/input/joystick/tmdc.c b/drivers/input/joystick/tmdc.c
index 0feeb8a..60c37bc 100644
--- a/drivers/input/joystick/tmdc.c
+++ b/drivers/input/joystick/tmdc.c
@@ -1,6 +1,4 @@
 /*
- * $Id: tmdc.c,v 1.31 2002/01/22 20:29:52 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  *
  *   Based on the work of:
diff --git a/drivers/input/joystick/turbografx.c b/drivers/input/joystick/turbografx.c
index 989483f..b6f8598 100644
--- a/drivers/input/joystick/turbografx.c
+++ b/drivers/input/joystick/turbografx.c
@@ -1,6 +1,4 @@
 /*
- * $Id: turbografx.c,v 1.14 2002/01/22 20:30:39 vojtech Exp $
- *
  *  Copyright (c) 1998-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/joystick/twidjoy.c b/drivers/input/joystick/twidjoy.c
index 1085c84..3f4ec73 100644
--- a/drivers/input/joystick/twidjoy.c
+++ b/drivers/input/joystick/twidjoy.c
@@ -1,8 +1,4 @@
 /*
- * $Id: twidjoy.c,v 1.5 2002/01/22 20:31:53 vojtech Exp $
- *
- *  derived from CVS-ID "stinger.c,v 1.5 2001/05/29 12:57:18 vojtech Exp"
- *
  *  Copyright (c) 2001 Arndt Schoenewald
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *  Copyright (c) 2000 Mark Fletcher
diff --git a/drivers/input/joystick/warrior.c b/drivers/input/joystick/warrior.c
index e928b6e..f72c83e 100644
--- a/drivers/input/joystick/warrior.c
+++ b/drivers/input/joystick/warrior.c
@@ -1,6 +1,4 @@
 /*
- * $Id: warrior.c,v 1.14 2002/01/22 20:32:10 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 81bf756..35149ec 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: amikbd.c,v 1.13 2002/02/01 16:02:24 vojtech Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index be0f5d1..9fce6d1 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: sunkbd.c,v 1.14 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/keyboard/xtkbd.c b/drivers/input/keyboard/xtkbd.c
index 152a2c0..37b01d7 100644
--- a/drivers/input/keyboard/xtkbd.c
+++ b/drivers/input/keyboard/xtkbd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: xtkbd.c,v 1.11 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 06c35fc..3827a22 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -1,6 +1,4 @@
 /*
- * $Id: inport.c,v 1.11 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
index 9ea8955..e241311 100644
--- a/drivers/input/mouse/logibm.c
+++ b/drivers/input/mouse/logibm.c
@@ -1,6 +1,4 @@
 /*
- * $Id: logibm.c,v 1.11 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/mouse/pc110pad.c b/drivers/input/mouse/pc110pad.c
index 61cff83..fd09c8d 100644
--- a/drivers/input/mouse/pc110pad.c
+++ b/drivers/input/mouse/pc110pad.c
@@ -1,6 +1,4 @@
 /*
- * $Id: pc110pad.c,v 1.12 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/mouse/sermouse.c b/drivers/input/mouse/sermouse.c
index ed917bf..17ff137 100644
--- a/drivers/input/mouse/sermouse.c
+++ b/drivers/input/mouse/sermouse.c
@@ -1,6 +1,4 @@
 /*
- * $Id: sermouse.c,v 1.17 2002/03/13 10:03:43 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index 0d35018..d1380fc 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -1,6 +1,4 @@
 /*
- * $Id: ct82c710.c,v 1.11 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 1999-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index cb89aff..eca125c 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: q40kbd.c,v 1.12 2002/02/02 22:26:44 vojtech Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *
  *  Based on the work of:
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 34c59d9..1567b77 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: rpckbd.c,v 1.7 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  *  Copyright (c) 2002 Russell King
  */
diff --git a/drivers/input/touchscreen/gunze.c b/drivers/input/touchscreen/gunze.c
index a48a158..a54f90e 100644
--- a/drivers/input/touchscreen/gunze.c
+++ b/drivers/input/touchscreen/gunze.c
@@ -1,6 +1,4 @@
 /*
- * $Id: gunze.c,v 1.12 2001/09/25 10:12:07 vojtech Exp $
- *
  *  Copyright (c) 2000-2001 Vojtech Pavlik
  */
 
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index 28ae15e..4f86081 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -1,6 +1,4 @@
 /*
- * $Id: h3600_ts_input.c,v 1.4 2002/01/23 06:39:37 jsimmons Exp $
- *
  *  Copyright (c) 2001 "Crazy" James Simmons jsimmons@transvirtual.com
  *
  *  Sponsored by Transvirtual Technology.
diff --git a/include/linux/joystick.h b/include/linux/joystick.h
index e2d3a18..b5e0512 100644
--- a/include/linux/joystick.h
+++ b/include/linux/joystick.h
@@ -2,8 +2,6 @@
 #define _LINUX_JOYSTICK_H
 
 /*
- * $Id: joystick.h,v 1.3 2000/11/30 11:07:05 vojtech Exp $
- *
  *  Copyright (C) 1996-2000 Vojtech Pavlik
  *
  *  Sponsored by SuSE

