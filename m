Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbXEOTgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbXEOTgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbXEOTgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:36:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45120 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479AbXEOTgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:36:21 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] missing dependencies for USB drivers in input
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Message-Id: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:36:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


stuff that does select USB should depend on USB_ARCH_HAS_HCD, or we'll
end up with unbuildable configs.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/input/joystick/Kconfig    |    1 +
 drivers/input/misc/Kconfig        |    5 +++++
 drivers/input/mouse/Kconfig       |    1 +
 drivers/input/tablet/Kconfig      |    4 ++++
 drivers/input/touchscreen/Kconfig |    1 +
 5 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 82f563e..b002345 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -255,6 +255,7 @@ config JOYSTICK_JOYDUMP
 
 config JOYSTICK_XPAD
 	tristate "X-Box gamepad support"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use the X-Box pad with your computer.
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 6013ace..842a7b4 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -84,6 +84,7 @@ config INPUT_ATLAS_BTNS
 
 config INPUT_ATI_REMOTE
 	tristate "ATI / X10 USB RF remote control"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use an ATI or X10 "Lola" USB remote control.
@@ -99,6 +100,7 @@ config INPUT_ATI_REMOTE
 
 config INPUT_ATI_REMOTE2
 	tristate "ATI / Philips USB RF remote control"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use an ATI or Philips USB RF remote control.
@@ -114,6 +116,7 @@ config INPUT_ATI_REMOTE2
 config INPUT_KEYSPAN_REMOTE
 	tristate "Keyspan DMR USB remote control (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use a Keyspan DMR USB remote control.
@@ -128,6 +131,7 @@ config INPUT_KEYSPAN_REMOTE
 
 config INPUT_POWERMATE
 	tristate "Griffin PowerMate and Contour Jog support"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use Griffin PowerMate or Contour Jog devices.
@@ -144,6 +148,7 @@ config INPUT_POWERMATE
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
 	depends EXPERIMENTAL
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to enable keyboard and LCD functions of the
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 2ccc114..eb0167e 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -111,6 +111,7 @@ config MOUSE_SERIAL
 
 config MOUSE_APPLETOUCH
 	tristate "Apple USB Touchpad support"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use an Apple USB Touchpad.
diff --git a/drivers/input/tablet/Kconfig b/drivers/input/tablet/Kconfig
index 12dfb0e..d371c0b 100644
--- a/drivers/input/tablet/Kconfig
+++ b/drivers/input/tablet/Kconfig
@@ -13,6 +13,7 @@ if INPUT_TABLET
 
 config TABLET_USB_ACECAD
 	tristate "Acecad Flair tablet support (USB)"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use the USB version of the Acecad Flair
@@ -25,6 +26,7 @@ config TABLET_USB_ACECAD
 
 config TABLET_USB_AIPTEK
 	tristate "Aiptek 6000U/8000U tablet support (USB)"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use the USB version of the Aiptek 6000U
@@ -49,6 +51,7 @@ config TABLET_USB_GTCO
 
 config TABLET_USB_KBTAB
 	tristate "KB Gear JamStudio tablet support (USB)"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use the USB version of the KB Gear
@@ -61,6 +64,7 @@ config TABLET_USB_KBTAB
 
 config TABLET_USB_WACOM
 	tristate "Wacom Intuos/Graphire tablet support (USB)"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  Say Y here if you want to use the USB version of the Wacom Intuos
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 5e640ae..4f09180 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -166,6 +166,7 @@ config TOUCHSCREEN_UCB1400
 
 config TOUCHSCREEN_USB_COMPOSITE
 	tristate "USB Touchscreen Driver"
+	depends on USB_ARCH_HAS_HCD
 	select USB
 	help
 	  USB Touchscreen driver for:
-- 
1.5.0-rc2.GIT


