Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbYGQT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbYGQT2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbYGQTXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:07 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:52674 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbYGQTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:52 -0400
Message-Id: <20080717191756.252792622@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:31 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 24/29] m68k/Atari: remove the dead ATARI_SCC{,_DMA} options
Content-Disposition: inline; filename=m68k-atari-remove-the-dead-ATARI_SCC-options.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

It seems the driver was removed back in kernel 2.3 but the options were 
forgotten.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

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

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

