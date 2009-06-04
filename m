Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZFDOla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZFDOla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZFDOlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:41:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52079 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbZFDOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:41:22 -0400
Date: Thu, 4 Jun 2009 16:41:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trivial patch monkey <trivial@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Kconfig: .ko is normally not included in module names, make it
	consistent
Message-ID: <20090604144118.GA30487@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


.ko is normally not included in Kconfig help, make it consistent.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
commit 67bab97b212ed399459e2babf8268b5411c28dff
tree 9e8645c55ada7e6518cd6a1749764daada7f8376
parent 7ca0c98aa0bc0d6d3c27ab40e1ca4021a72b960d
author Pavel <pavel@ucw.cz> Thu, 04 Jun 2009 16:40:29 +0200
committer Pavel <pavel@ucw.cz> Thu, 04 Jun 2009 16:40:29 +0200

 arch/blackfin/Kconfig                |    2 +-
 drivers/block/Kconfig                |    2 +-
 drivers/char/Kconfig                 |    2 +-
 drivers/connector/Kconfig            |    2 +-
 drivers/ide/Kconfig                  |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig    |    2 +-
 drivers/mtd/devices/Kconfig          |    2 +-
 drivers/mtd/nand/Kconfig             |    4 ++--
 drivers/net/Kconfig                  |    4 ++--
 drivers/net/wireless/Kconfig         |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig |    4 ++--
 drivers/w1/Kconfig                   |    2 +-
 drivers/w1/masters/Kconfig           |    6 +++---
 drivers/watchdog/Kconfig             |    2 +-
 net/ipv6/Kconfig                     |    2 +-
 15 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 3640cdc..bc9ce89 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -872,7 +872,7 @@ config BFIN_GPTIMERS
 	  are unsure, say N.
 
 	  To compile this driver as a module, choose M here: the module
-	  will be called gptimers.ko.
+	  will be called gptimers.
 
 choice
 	prompt "Uncached DMA region"
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ddea8e4..f2e5764 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -112,7 +112,7 @@ config GDROM
 	  with up to 1 GB of data. This drive will also read standard CD ROM
 	  disks. Select this option to access any disks in your GD ROM drive.
 	  Most users will want to say "Y" here.
-	  You can also build this as a module which will be called gdrom.ko
+	  You can also build this as a module which will be called gdrom.
 
 source "drivers/block/paride/Kconfig"
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 735bbe2..73e85ad 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -679,7 +679,7 @@ config HVCS
 	  this driver.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called hvcs.ko.  Additionally, this module
+	  module will be called hvcs.  Additionally, this module
 	  will depend on arch specific APIs exported from hvcserver.ko
 	  which will also be compiled when this driver is built as a
 	  module.
diff --git a/drivers/connector/Kconfig b/drivers/connector/Kconfig
index 100bfd4..6e6730f 100644
--- a/drivers/connector/Kconfig
+++ b/drivers/connector/Kconfig
@@ -7,7 +7,7 @@ menuconfig CONNECTOR
 	  of the netlink socket protocol.
 
 	  Connector support can also be built as a module.  If so, the module
-	  will be called cn.ko.
+	  will be called cn.
 
 if CONNECTOR
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index cf06494..9a5d0aa 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -46,7 +46,7 @@ menuconfig IDE
 	  SMART parameters from disk drives.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called ide-core.ko.
+	  module will be called ide-core.
 
 	  For further information, please read <file:Documentation/ide/ide.txt>.
 
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 60955a7..1bb66e1 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -216,7 +216,7 @@ config DVB_USB_TTUSB2
 	help
 	  Say Y here to support the Pinnacle 400e DVB-S USB2.0 receiver. The
 	  firmware protocol used by this module is similar to the one used by the
-	  old ttusb-driver - that's why the module is called dvb-usb-ttusb2.ko.
+	  old ttusb-driver - that's why the module is called dvb-usb-ttusb2.
 
 config DVB_USB_DTT200U
 	tristate "WideView WT-200U and WT-220U (pen) DVB-T USB2.0 support (Yakumo/Hama/Typhoon/Yuan)"
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 6fde0a2..325fab9 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -49,7 +49,7 @@ config MTD_MS02NV
 	  If you want to compile this driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.
-	  The module will be called ms02-nv.ko.
+	  The module will be called ms02-nv.
 
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 890936d..f327689 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -260,7 +260,7 @@ config MTD_NAND_BASLER_EXCITE
 	help
           This enables the driver for the NAND flash device found on the
           Basler eXcite Smart Camera. If built as a module, the driver
-          will be named "excite_nandflash.ko".
+          will be named excite_nandflash.
 
 config MTD_NAND_CAFE
 	tristate "NAND support for OLPC CAFĂ chip"
@@ -282,7 +282,7 @@ config MTD_NAND_CS553X
 	  controller is enabled for NAND, and currently requires that
 	  the controller be in MMIO mode.
 
-	  If you say "m", the module will be called "cs553x_nand.ko".
+	  If you say "m", the module will be called cs553x_nand.
 
 config MTD_NAND_ATMEL
 	tristate "Support for NAND Flash / SmartMedia on AT91 and AVR32"
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 214a92d..b4683ce 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1880,7 +1880,7 @@ config FEC_MPC52xx
 	---help---
 	  This option enables support for the MPC5200's on-chip
 	  Fast Ethernet Controller
-	  If compiled as module, it will be called 'fec_mpc52xx.ko'.
+	  If compiled as module, it will be called fec_mpc52xx.
 
 config FEC_MPC52xx_MDIO
 	bool "MPC52xx FEC MDIO bus driver"
@@ -1892,7 +1892,7 @@ config FEC_MPC52xx_MDIO
 	  (Motorola? industry standard).
 	  If your board uses an external PHY connected to FEC, enable this.
 	  If not sure, enable.
-	  If compiled as module, it will be called 'fec_mpc52xx_phy.ko'.
+	  If compiled as module, it will be called fec_mpc52xx_phy.
 
 config NE_H8300
 	tristate "NE2000 compatible support for H8/300"
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8a08235..25b56d2 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -310,7 +310,7 @@ config PRISM54
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.
-	  The module will be called prism54.ko.
+	  The module will be called prism54.
 
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 8304f64..7361623 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -75,7 +75,7 @@ config IWLAGN
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
-	  module will be called iwlagn.ko.
+	  module will be called iwlagn.
 
 
 config IWL4965
@@ -113,7 +113,7 @@ config IWL3945
 	  If you want to compile the driver as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
-	  module will be called iwl3945.ko.
+	  module will be called iwl3945.
 
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 driver"
diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
index 9adbb4f..fd2c7bd 100644
--- a/drivers/w1/Kconfig
+++ b/drivers/w1/Kconfig
@@ -8,7 +8,7 @@ menuconfig W1
 	  If you want W1 support, you should say Y here.
 
 	  This W1 support can also be built as a module.  If so, the module
-	  will be called wire.ko.
+	  will be called wire.
 
 if W1
 
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 96d2f8e..3195fb8 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -12,7 +12,7 @@ config W1_MASTER_MATROX
 	  using Matrox's G400 GPIO pins.
 
 	  This support is also available as a module.  If so, the module
-	  will be called matrox_w1.ko.
+	  will be called matrox_w1.
 
 config W1_MASTER_DS2490
 	tristate "DS2490 USB <-> W1 transport layer for 1-wire"
@@ -22,7 +22,7 @@ config W1_MASTER_DS2490
 	  for example DS9490*.
 
   	  This support is also available as a module.  If so, the module
-	  will be called ds2490.ko.
+	  will be called ds2490.
 
 config W1_MASTER_DS2482
 	tristate "Maxim DS2482 I2C to 1-Wire bridge"
@@ -56,7 +56,7 @@ config W1_MASTER_GPIO
 	  GPIO pins. This driver uses the GPIO API to control the wire.
 
 	  This support is also available as a module.  If so, the module
-	  will be called w1-gpio.ko.
+	  will be called w1-gpio.
 
 config HDQ_MASTER_OMAP
 	tristate "OMAP HDQ driver"
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 5eb8f21..452082f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -531,7 +531,7 @@ config SBC8360_WDT
 	  Board Computer produced by Axiomtek Co., Ltd. (www.axiomtek.com).
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called sbc8360.ko.
+	  module will be called sbc8360.
 
 	  Most people will say N.
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index ca8cb32..ead6c7a 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -168,7 +168,7 @@ config IPV6_SIT
 	  into IPv4 packets. This is useful if you want to connect two IPv6
 	  networks over an IPv4-only path.
 
-	  Saying M here will produce a module called sit.ko. If unsure, say Y.
+	  Saying M here will produce a module called sit. If unsure, say Y.
 
 config IPV6_NDISC_NODETYPE
 	bool

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
