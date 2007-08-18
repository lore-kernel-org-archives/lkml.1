Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXHRK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXHRK44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbXHRK4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:56:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53319 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXHRK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:56:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Aug 2007 12:56:21 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Add some help texts to recently-introduced kconfig items
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0708132009510.9759@fbirervta.pbzchgretzou.qr>
Message-ID: <tkrat.773d63ed4fb869d9@s5r6.in-berlin.de>
References: <46C09C1A.7050706@googlemail.com>
 <Pine.LNX.4.64.0708132009510.9759@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Aug, Jan Engelhardt wrote:
> 
> On Aug 13 2007 19:59, Michal Piotrowski wrote:
>>
>>Subject         : Kconfig prompts without help text
>>References      : http://lkml.org/lkml/2007/7/16/326
>>Last known good : ?
>>Submitter       : Stefan Richter <stefanr@s5r6.in-berlin.de>
>>Caused-By       : ?
>>Handled-By      : Jan Engelhardt <jengelh@linux01.gwdg.de>
>>Patch           : http://lkml.org/lkml/2007/7/18/236
>>Status          : patch available
> 
> Is there some special magic needed (like resubmit), or will you slurp this one
> yourself?


From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Add some help texts to recently-introduced kconfig items

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (edited MACINTOSH_DRIVERS per Geert Uytterhoeven's remark)
---

fixes a regression in 2.6.23-rc1:  new Kconfig prompts without help text

 arch/i386/Kconfig          |    5 +++++
 drivers/atm/Kconfig        |    5 +++++
 drivers/auxdisplay/Kconfig |    5 +++++
 drivers/block/Kconfig      |    6 ++++++
 drivers/crypto/Kconfig     |    5 +++++
 drivers/hid/Kconfig        |    5 +++++
 drivers/kvm/Kconfig        |    5 +++++
 drivers/macintosh/Kconfig  |    5 +++++
 drivers/misc/Kconfig       |    5 +++++
 drivers/net/Kconfig        |   15 +++++++++++++++
 drivers/usb/Kconfig        |    3 +++
 11 files changed, 64 insertions(+)

Index: linux-2.6.23-rc3/arch/i386/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/arch/i386/Kconfig
+++ linux-2.6.23-rc3/arch/i386/Kconfig
@@ -1228,6 +1228,11 @@ menuconfig INSTRUMENTATION
 	bool "Instrumentation Support"
 	depends on EXPERIMENTAL
 	default y
+	---help---
+	  Say Y here to get to see options related to performance measurement,
+	  debugging, and testing. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if INSTRUMENTATION
 
Index: linux-2.6.23-rc3/drivers/atm/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/atm/Kconfig
+++ linux-2.6.23-rc3/drivers/atm/Kconfig
@@ -6,6 +6,11 @@ menuconfig ATM_DRIVERS
 	bool "ATM drivers"
 	depends on NETDEVICES && ATM
 	default y
+	---help---
+	  Say Y here to get to see options for Asynchronous Transfer Mode
+	  device drivers. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if ATM_DRIVERS && NETDEVICES && ATM
 
Index: linux-2.6.23-rc3/drivers/auxdisplay/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/auxdisplay/Kconfig
+++ linux-2.6.23-rc3/drivers/auxdisplay/Kconfig
@@ -8,6 +8,11 @@
 menuconfig AUXDISPLAY
 	depends on PARPORT
 	bool "Auxiliary Display support"
+	---help---
+	  Say Y here to get to see options for auxiliary display drivers.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if AUXDISPLAY && PARPORT
 
Index: linux-2.6.23-rc3/drivers/block/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/block/Kconfig
+++ linux-2.6.23-rc3/drivers/block/Kconfig
@@ -6,6 +6,12 @@ menuconfig BLK_DEV
 	bool "Block devices"
 	depends on BLOCK
 	default y
+	---help---
+	  Say Y here to get to see options for various different block device
+	  drivers. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled;
+	  only do this if you know what you are doing.
 
 if BLK_DEV
 
Index: linux-2.6.23-rc3/drivers/crypto/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/crypto/Kconfig
+++ linux-2.6.23-rc3/drivers/crypto/Kconfig
@@ -2,6 +2,11 @@
 menuconfig CRYPTO_HW
 	bool "Hardware crypto devices"
 	default y
+	---help---
+	  Say Y here to get to see options for hardware crypto devices and
+	  processors. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if CRYPTO_HW
 
Index: linux-2.6.23-rc3/drivers/hid/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/hid/Kconfig
+++ linux-2.6.23-rc3/drivers/hid/Kconfig
@@ -5,6 +5,11 @@ menuconfig HID_SUPPORT
 	bool "HID Devices"
 	depends on INPUT
 	default y
+	---help---
+	  Say Y here to get to see options for various computer-human interface
+	  device drivers. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if HID_SUPPORT
 
Index: linux-2.6.23-rc3/drivers/kvm/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/kvm/Kconfig
+++ linux-2.6.23-rc3/drivers/kvm/Kconfig
@@ -5,6 +5,11 @@ menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	depends on X86
 	default y
+	---help---
+	  Say Y here to get to see options for virtualization guest drivers.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if VIRTUALIZATION
 
Index: linux-2.6.23-rc3/drivers/macintosh/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/macintosh/Kconfig
+++ linux-2.6.23-rc3/drivers/macintosh/Kconfig
@@ -3,6 +3,11 @@ menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
 	default y if (PPC_PMAC || MAC)
+	---help---
+	  Say Y here to get to see options for devices used with Macintosh
+	  computers. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if MACINTOSH_DRIVERS
 
Index: linux-2.6.23-rc3/drivers/misc/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/misc/Kconfig
+++ linux-2.6.23-rc3/drivers/misc/Kconfig
@@ -5,6 +5,11 @@
 menuconfig MISC_DEVICES
 	bool "Misc devices"
 	default y
+	---help---
+	  Say Y here to get to see options for device drivers from various
+	  different categories. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if MISC_DEVICES
 
Index: linux-2.6.23-rc3/drivers/net/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/net/Kconfig
+++ linux-2.6.23-rc3/drivers/net/Kconfig
@@ -1968,6 +1968,16 @@ menuconfig NETDEV_1000
 	bool "Ethernet (1000 Mbit)"
 	depends on !UML
 	default y
+	---help---
+	  Ethernet (also called IEEE 802.3 or ISO 8802-2) is the most common
+	  type of Local Area Network (LAN) in universities and companies.
+
+	  Say Y here to get to see options for Gigabit Ethernet drivers.
+	  This option alone does not add any kernel code.
+	  Note that drivers supporting both 100 and 1000 MBit may be listed
+	  under "Ethernet (10 or 100MBit)" instead.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if NETDEV_1000
 
@@ -2339,6 +2349,11 @@ menuconfig NETDEV_10000
 	bool "Ethernet (10000 Mbit)"
 	depends on !UML
 	default y
+	---help---
+	  Say Y here to get to see options for 10 Gigabit Ethernet drivers.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if NETDEV_10000
 
Index: linux-2.6.23-rc3/drivers/usb/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/drivers/usb/Kconfig
+++ linux-2.6.23-rc3/drivers/usb/Kconfig
@@ -6,6 +6,9 @@ menuconfig USB_SUPPORT
 	bool "USB support"
 	depends on HAS_IOMEM
 	default y
+	---help---
+	  This option adds core support for Universal Serial Bus (USB).
+	  You will also need drivers from the following menu to make use of it.
 
 if USB_SUPPORT
 



-- 
Stefan Richter
-=====-=-=== =--- =--=-
http://arcgraph.de/sr/

