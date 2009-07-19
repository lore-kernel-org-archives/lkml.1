Return-Path: <linux-kernel-owner+w=401wt.eu-S1751132AbZGST2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbZGST2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZGST2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:28:22 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:55188 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZGST2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Uf5Yv84WhcKyEXWqP+rMbfCy36wX7XJhCXCgY/CPESCRj4ciCpzuFOdGSzZyAuwsAt
         36U6VucoC7+QM4yLkWNTArmPpmcYRVrOHdekj0wZaKrn7tgKjvDQEkJwEsQw4kR2usWr
         dzh/kFowQah+GHXoJXelAKGzgGgSZdSASqOEI=
Message-ID: <4A6373C3.7060304@gmail.com>
Date: Sun, 19 Jul 2009 21:28:03 +0200
From: Henk Martijn <h.h.martijn@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: jkosina@suse.cz, jirislaby@gmail.com, jussi.kivilinna@mbnet.fi,
       tomas.hanak@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: Don't hide HID drivers behind EMBEDDED
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to minimizing my .config I found that couldn't deselect some HID drivers because they were hidden behind EMBEDDED. What's the reason?
What about the following:


---
 drivers/hid/Kconfig |   54 +++++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7831a03..274d7e2 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -71,14 +71,14 @@ menu "Special HID drivers"
 	depends on HID
 
 config HID_A4TECH
-	tristate "A4 tech" if EMBEDDED
+	tristate "A4 tech"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
 config HID_APPLE
-	tristate "Apple" if EMBEDDED
+	tristate "Apple"
 	depends on (USB_HID || BT_HIDP)
 	default !EMBEDDED
 	---help---
@@ -89,35 +89,35 @@ config HID_APPLE
 	MacBooks, MacBook Pros and Apple Aluminum.
 
 config HID_BELKIN
-	tristate "Belkin" if EMBEDDED
+	tristate "Belkin"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
 config HID_CHERRY
-	tristate "Cherry" if EMBEDDED
+	tristate "Cherry"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
-	tristate "Chicony" if EMBEDDED
+	tristate "Chicony"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Chicony Tactical pad.
 
 config HID_CYPRESS
-	tristate "Cypress" if EMBEDDED
+	tristate "Cypress"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for cypress mouse and barcode readers.
 
 config HID_DRAGONRISE
-	tristate "DragonRise Inc. support" if EMBEDDED
+	tristate "DragonRise Inc. support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -132,35 +132,35 @@ config DRAGONRISE_FF
 	game controllers.
 
 config HID_EZKEY
-	tristate "Ezkey" if EMBEDDED
+	tristate "Ezkey"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
 config HID_KYE
-	tristate "Kye" if EMBEDDED
+	tristate "Kye"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Kye/Genius Ergo Mouse.
 
 config HID_GYRATION
-	tristate "Gyration" if EMBEDDED
+	tristate "Gyration"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Gyration remote control.
 
 config HID_KENSINGTON
-	tristate "Kensington" if EMBEDDED
+	tristate "Kensington"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Kensington Slimblade Trackball.
 
 config HID_LOGITECH
-	tristate "Logitech" if EMBEDDED
+	tristate "Logitech"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -191,35 +191,35 @@ config LOGIRUMBLEPAD2_FF
 	  Rumblepad 2 devices.
 
 config HID_MICROSOFT
-	tristate "Microsoft" if EMBEDDED
+	tristate "Microsoft"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
 config HID_MONTEREY
-	tristate "Monterey" if EMBEDDED
+	tristate "Monterey"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Monterey Genius KB29E.
 
 config HID_NTRIG
-	tristate "NTrig" if EMBEDDED
+	tristate "NTrig"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for N-Trig touch screen.
 
 config HID_PANTHERLORD
-	tristate "Pantherlord devices support" if EMBEDDED
+	tristate "Pantherlord devices support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for PantherLord/GreenAsia based device support.
 
 config HID_PANTHERLORD
-	tristate "Pantherlord support" if EMBEDDED
+	tristate "Pantherlord support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -235,35 +235,35 @@ config PANTHERLORD_FF
 	  or adapter and want to enable force feedback support for it.
 
 config HID_PETALYNX
-	tristate "Petalynx" if EMBEDDED
+	tristate "Petalynx"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Petalynx Maxter remote control.
 
 config HID_SAMSUNG
-	tristate "Samsung" if EMBEDDED
+	tristate "Samsung"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Samsung InfraRed remote control.
 
 config HID_SONY
-	tristate "Sony" if EMBEDDED
+	tristate "Sony"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Sony PS3 controller.
 
 config HID_SUNPLUS
-	tristate "Sunplus" if EMBEDDED
+	tristate "Sunplus"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Support for Sunplus wireless desktop.
 
 config HID_GREENASIA
-	tristate "GreenAsia (Product ID 0x12) support" if EMBEDDED
+	tristate "GreenAsia (Product ID 0x12) support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -280,7 +280,7 @@ config GREENASIA_FF
 	and want to enable force feedback support for it.
 
 config HID_SMARTJOYPLUS
-	tristate "SmartJoy PLUS PS2/USB adapter support" if EMBEDDED
+	tristate "SmartJoy PLUS PS2/USB adapter support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -295,14 +295,14 @@ config SMARTJOYPLUS_FF
 	enable force feedback support for it.
 
 config HID_TOPSEED
-	tristate "TopSeed Cyberlink remote control support" if EMBEDDED
+	tristate "TopSeed Cyberlink remote control support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
 	Say Y if you have a TopSeed Cyberlink remote control.
 
 config HID_THRUSTMASTER
-	tristate "ThrustMaster devices support" if EMBEDDED
+	tristate "ThrustMaster devices support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
@@ -319,14 +319,14 @@ config THRUSTMASTER_FF
 	  want to enable force feedback support for it.
 
 config HID_WACOM
-	tristate "Wacom Bluetooth devices support" if EMBEDDED
+	tristate "Wacom Bluetooth devices support"
 	depends on BT_HIDP
 	default !EMBEDDED
 	---help---
 	Support for Wacom Graphire Bluetooth tablet.
 
 config HID_ZEROPLUS
-	tristate "Zeroplus based game controller support" if EMBEDDED
+	tristate "Zeroplus based game controller support"
 	depends on USB_HID
 	default !EMBEDDED
 	---help---
-- 
1.6.0.2



