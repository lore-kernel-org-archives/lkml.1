Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYLAGD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYLAGD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYLAGDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:03:47 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:55902 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYLAGDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:03:46 -0500
Date: Mon, 01 Dec 2008 01:03:40 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/2] drivers/misc/Makefile, Kconfig: cleanup
In-reply-to: <alpine.LFD.2.00.0812010053100.3314@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, x86@kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812010102340.3314@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
 <4930307C.30106@oracle.com> <20081129083550.3c23af37.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.0811281649001.24773@localhost.localdomain>
 <alpine.LFD.2.00.0811281702570.24773@localhost.localdomain>
 <alpine.LFD.2.00.0811281706540.24773@localhost.localdomain>
 <20081128223533.GA5175@uranus.ravnborg.org>
 <alpine.LFD.2.00.0811281801520.24773@localhost.localdomain>
 <20081129073816.GB8351@uranus.ravnborg.org>
 <alpine.LFD.2.00.0812010053100.3314@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

tabs->space and delete unnecessary dummy build-in.o rule.

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/misc/Kconfig  |   42 +++++++++++++++++++++---------------------
 drivers/misc/Makefile |    3 ---
 2 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fee7304..dcf6169 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -120,7 +120,7 @@ config TIFM_CORE
 	  cards are supported via 'MMC/SD Card support: TI Flash Media MMC/SD
 	  Interface support (MMC_TIFM_SD)'.
 
-          To compile this driver as a module, choose M here: the module will
+	  To compile this driver as a module, choose M here: the module will
 	  be called tifm_core.
 
 config TIFM_7XX1
@@ -133,11 +133,11 @@ config TIFM_7XX1
 	  To make actual use of the device, you will have to select some
 	  flash card format drivers, as outlined in the TIFM_CORE Help.
 
-          To compile this driver as a module, choose M here: the module will
+	  To compile this driver as a module, choose M here: the module will
 	  be called tifm_7xx1.
 
 config ACER_WMI
-        tristate "Acer WMI Laptop Extras (EXPERIMENTAL)"
+	tristate "Acer WMI Laptop Extras (EXPERIMENTAL)"
 	depends on X86
 	depends on EXPERIMENTAL
 	depends on ACPI
@@ -159,14 +159,14 @@ config ACER_WMI
 	  here.
 
 config ASUS_LAPTOP
-        tristate "Asus Laptop Extras (EXPERIMENTAL)"
-        depends on X86
-        depends on ACPI
+	tristate "Asus Laptop Extras (EXPERIMENTAL)"
+	depends on X86
+	depends on ACPI
 	depends on EXPERIMENTAL && !ACPI_ASUS
 	depends on LEDS_CLASS
 	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
+	---help---
 	  This is the new Linux driver for Asus laptops. It may also support some
 	  MEDION, JVC or VICTOR laptops. It makes all the extra buttons generate
 	  standard ACPI events that go through /proc/acpi/events. It also adds
@@ -179,12 +179,12 @@ config ASUS_LAPTOP
 	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
 
 config FUJITSU_LAPTOP
-        tristate "Fujitsu Laptop Extras"
-        depends on X86
-        depends on ACPI
+	tristate "Fujitsu Laptop Extras"
+	depends on X86
+	depends on ACPI
 	depends on INPUT
-        depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
+	depends on BACKLIGHT_CLASS_DEVICE
+	---help---
 	  This is a driver for laptops built by Fujitsu:
 
 	    * P2xxx/P5xxx/S6xxx/S7xxx series Lifebooks
@@ -221,11 +221,11 @@ config HP_WMI
        depends on INPUT
        depends on RFKILL
        help
-         Say Y here if you want to support WMI-based hotkeys on HP laptops and
+	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
 	 to read data from WMI such as docking or ambient light sensor state.
 
-         To compile this driver as a module, choose M here: the module will
-         be called hp-wmi.
+	 To compile this driver as a module, choose M here: the module will
+	 be called hp-wmi.
 
 config ICS932S401
 	tristate "Integrated Circuits ICS932S401"
@@ -238,11 +238,11 @@ config ICS932S401
 	  will be called ics932s401.
 
 config MSI_LAPTOP
-        tristate "MSI Laptop Extras"
-        depends on X86
-        depends on ACPI
-        depends on BACKLIGHT_CLASS_DEVICE
-        ---help---
+	tristate "MSI Laptop Extras"
+	depends on X86
+	depends on ACPI
+	depends on BACKLIGHT_CLASS_DEVICE
+	---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
 
@@ -259,7 +259,7 @@ config MSI_LAPTOP
 config PANASONIC_LAPTOP
 	tristate "Panasonic Laptop Extras"
 	depends on X86 && INPUT && ACPI
-        depends on BACKLIGHT_CLASS_DEVICE
+	depends on BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to backlight control and hotkeys
 	  on Panasonic Let's Note laptops.
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 817f7f5..bcde73b 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -1,9 +1,6 @@
 #
 # Makefile for misc devices that really don't fit anywhere else.
 #
-obj- := misc.o	# Dummy rule to force built-in.o to be made
-
-obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
 obj-$(CONFIG_EEEPC_LAPTOP)	+= eeepc-laptop.o
-- 
1.5.6.5


