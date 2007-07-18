Return-Path: <linux-kernel-owner+w=401wt.eu-S934713AbXGRRSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713AbXGRRSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762723AbXGRRRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:17:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58992 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762839AbXGRRRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:17:51 -0400
Date: Wed, 18 Jul 2007 19:17:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
In-Reply-To: <20070718094119.4a26ae03.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0707181916410.5385@fbirervta.pbzchgretzou.qr>
References: <469BBDAD.2010908@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
 <20070718094119.4a26ae03.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18 2007 09:41, Randy Dunlap wrote:
>
>Looks good to me except that help text should be indented by
>2 more spaces according to CodingStyle.

Who invented that rule anyway... the "---help---" marker (note the dashes)
clearly separates things already.
Here you go.

===

Add some help texts to recently-introduced kconfig items

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 arch/i386/Kconfig          |    5 +++++
 drivers/atm/Kconfig        |    5 +++++
 drivers/auxdisplay/Kconfig |    5 +++++
 drivers/block/Kconfig      |    6 ++++++
 drivers/crypto/Kconfig     |    5 +++++
 drivers/hid/Kconfig        |    5 +++++
 drivers/kvm/Kconfig        |    5 +++++
 drivers/macintosh/Kconfig  |    6 ++++++
 drivers/misc/Kconfig       |    5 +++++
 drivers/net/Kconfig        |   15 +++++++++++++++
 drivers/usb/Kconfig        |    3 +++
 11 files changed, 65 insertions(+)

Index: linux-2.6.23/arch/i386/Kconfig
===================================================================
--- linux-2.6.23.orig/arch/i386/Kconfig
+++ linux-2.6.23/arch/i386/Kconfig
@@ -1216,6 +1216,11 @@ menuconfig INSTRUMENTATION
 	bool "Instrumentation Support"
 	depends on EXPERIMENTAL
 	default y
+	---help---
+	  Say Y here to get to see options related to performance measurement,
+	  debugging, and testing. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if INSTRUMENTATION
 
Index: linux-2.6.23/drivers/atm/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/atm/Kconfig
+++ linux-2.6.23/drivers/atm/Kconfig
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
 
Index: linux-2.6.23/drivers/auxdisplay/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/auxdisplay/Kconfig
+++ linux-2.6.23/drivers/auxdisplay/Kconfig
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
 
Index: linux-2.6.23/drivers/block/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/block/Kconfig
+++ linux-2.6.23/drivers/block/Kconfig
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
 
Index: linux-2.6.23/drivers/crypto/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/crypto/Kconfig
+++ linux-2.6.23/drivers/crypto/Kconfig
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
 
Index: linux-2.6.23/drivers/hid/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/hid/Kconfig
+++ linux-2.6.23/drivers/hid/Kconfig
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
 
Index: linux-2.6.23/drivers/kvm/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/kvm/Kconfig
+++ linux-2.6.23/drivers/kvm/Kconfig
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
 
Index: linux-2.6.23/drivers/macintosh/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/macintosh/Kconfig
+++ linux-2.6.23/drivers/macintosh/Kconfig
@@ -3,6 +3,12 @@ menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
 	default y if (PPC_PMAC || MAC)
+	---help---
+	  Say Y here to get to see options for devices used with Macintosh
+	  computers, both PPC and Intel based. This option alone does not add
+	  any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if MACINTOSH_DRIVERS
 
Index: linux-2.6.23/drivers/misc/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/misc/Kconfig
+++ linux-2.6.23/drivers/misc/Kconfig
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
 
Index: linux-2.6.23/drivers/net/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/net/Kconfig
+++ linux-2.6.23/drivers/net/Kconfig
@@ -1923,6 +1923,16 @@ menuconfig NETDEV_1000
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
 
@@ -2294,6 +2304,11 @@ menuconfig NETDEV_10000
 	bool "Ethernet (10000 Mbit)"
 	depends on !UML
 	default y
+	---help---
+	  Say Y here to get to see options for 10 Gigabit Ethernet drivers.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 if NETDEV_10000
 
Index: linux-2.6.23/drivers/usb/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/usb/Kconfig
+++ linux-2.6.23/drivers/usb/Kconfig
@@ -6,6 +6,9 @@ menuconfig USB_SUPPORT
 	bool "USB support"
 	depends on HAS_IOMEM
 	default y
+	---help---
+	  This option adds core support for Universal Serial Bus (USB).
+	  You will also need drivers from the following menu to make use of it.
 
 if USB_SUPPORT
 
