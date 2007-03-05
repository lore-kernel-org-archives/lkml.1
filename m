Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbXCEBuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbXCEBuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXCEBuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:50:12 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49965 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbXCEBt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:56 -0500
Date: Mon, 5 Mar 2007 02:49:56 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
Message-ID: <20070305014956.GE3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the OBSOLETE_OSS options 
for 2.6.22.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 sound/oss/Kconfig          |   27 ---------------------------
 sound/oss/dmasound/Kconfig |   14 --------------
 2 files changed, 41 deletions(-)

--- linux-2.6.21-rc2-mm1/sound/oss/Kconfig.old	2007-03-05 01:22:21.000000000 +0100
+++ linux-2.6.21-rc2-mm1/sound/oss/Kconfig	2007-03-05 01:22:36.000000000 +0100
@@ -5,20 +5,6 @@
 #
 # Prompt user for primary drivers.
 
-config OBSOLETE_OSS
-	bool "Obsolete OSS drivers"
-	depends on SOUND_PRIME
-	help
-	  This option enables support for obsolete OSS drivers that
-	  are scheduled for removal in the near future since there
-	  are ALSA drivers for the same hardware.
-
-	  Please contact Adrian Bunk <bunk@stusta.de> if you had to
-	  say Y here because your soundcard is not properly supported
-	  by ALSA.
-
-	  If unsure, say N.
-
 config SOUND_BT878
 	tristate "BT878 audio dma"
 	depends on SOUND_PRIME && PCI
@@ -45,19 +31,6 @@
 	  note that CONFIG_KGDB should not be enabled at the same
 	  time, since it also attempts to use this UART port.
 
-config SOUND_ES1371
-	tristate "Creative Ensoniq AudioPCI 97 (ES1371)"
-	depends on SOUND_PRIME && PCI && OBSOLETE_OSS
-	help
-	  Say Y or M if you have a PCI sound card utilizing the Ensoniq
-	  ES1371 chipset, such as Ensoniq's AudioPCI97. To find out if
-	  your sound card uses an ES1371 without removing your computer's
-	  cover, use lspci -n and look for the PCI ID 1274:1371. Since
-	  Ensoniq was bought by Creative Labs, Sound Blaster 64/PCI
-	  models are either ES1370 or ES1371 based. This driver differs
-	  slightly from OSS/Free, so PLEASE READ
-	  <file:Documentation/sound/oss/es1371>.
-
 config SOUND_ICH
 	tristate "Intel ICH (i8xx) audio support"
 	depends on SOUND_PRIME && PCI
--- linux-2.6.21-rc2-mm1/sound/oss/dmasound/Kconfig.old	2007-03-05 01:22:44.000000000 +0100
+++ linux-2.6.21-rc2-mm1/sound/oss/dmasound/Kconfig	2007-03-05 01:22:56.000000000 +0100
@@ -12,20 +12,6 @@
 	  want). If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.
 
-config DMASOUND_PMAC
-	tristate "PowerMac DMA sound support"
-	depends on PPC32 && PPC_PMAC && SOUND && I2C && OBSOLETE_OSS
- 	select DMASOUND
-	help
-	  If you want to use the internal audio of your PowerMac in Linux,
-	  answer Y to this question. This will provide a Sun-like /dev/audio,
-	  compatible with the Linux/i386 sound system. Otherwise, say N.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you
-	  want). If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.
-
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
 	depends on (AMIGA || APUS) && SOUND

