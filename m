Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbYFYQ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbYFYQ2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbYFYQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:43 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42945 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760172AbYFYQ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:41 -0400
Date: Wed, 25 Jun 2008 19:25:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] remove the dead ATARI_SCC{,_DMA} options
Message-ID: <20080625162536.GH10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the driver was removed back in kernel 2.3 but the options were 
forgotten.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/Kconfig |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

d7a47518b54b51accc11a9cbfd503d740dbec087 diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8012ff7..8c5e1de 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -490,28 +490,6 @@ config ATARI_MFPSER
 	  Note for Falcon users: You also have an MFP port, it's just not
 	  wired to the outside... But you could use the port under Linux.
 
-config ATARI_SCC
-	tristate "Atari SCC serial support"
-	depends on ATARI
-	---help---
-	  If you have serial ports based on a Zilog SCC chip (Modem2, Serial2,
-	  LAN) and like to use them under Linux, say Y. All built-in SCC's are
-	  supported (TT, MegaSTE, Falcon), and also the ST-ESCC. If you have
-	  two connectors for channel A (Serial2 and LAN), they are visible as
-	  two separate devices.
-
-	  To compile this driver as a module, choose M here.
-
-config ATARI_SCC_DMA
-	bool "Atari SCC serial DMA support"
-	depends on ATARI_SCC
-	help
-	  This enables DMA support for receiving data on channel A of the SCC.
-	  If you have a TT you may say Y here and read
-	  drivers/char/atari_SCC.README. All other users should say N here,
-	  because only the TT has SCC-DMA, even if your machine keeps claiming
-	  so at boot time.
-
 config ATARI_MIDI
 	tristate "Atari MIDI serial support"
 	depends on ATARI
@@ -628,7 +606,7 @@ config DN_SERIAL
 
 config SERIAL_CONSOLE
 	bool "Support for serial port console"
-	depends on (AMIGA || ATARI || MAC || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_SCC=y || ATARI_MIDI=y || MAC_SCC=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
+	depends on (AMIGA || ATARI || MAC || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || MAC_SCC=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
 	---help---
 	  If you say Y here, it will be possible to use a serial port as the
 	  system console (the system console is the device which receives all

