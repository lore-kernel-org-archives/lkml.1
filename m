Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbYGQT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbYGQT0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbYGQTW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:58 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:49824 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbYGQTWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:51 -0400
Message-Id: <20080717191755.958079386@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:30 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 23/29] m68k/Mac: remove the unused ADB_KEYBOARD option
Content-Disposition: inline; filename=m68k-mac-remove-the-unused-ADB_KEYBOARD-option.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

When the driver was removed back in 2002 the option was forgotten.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -578,18 +578,6 @@ config MAC_HID
 	depends on INPUT_ADBHID
 	default y
 
-config ADB_KEYBOARD
-	bool "Support for ADB keyboard (old driver)"
-	depends on MAC && !INPUT_ADBHID
-	help
-	  This option allows you to use an ADB keyboard attached to your
-	  machine. Note that this disables any other (ie. PS/2) keyboard
-	  support, even if your machine is physically capable of using both at
-	  the same time.
-
-	  If you use an ADB keyboard (4 pin connector), say Y here.
-	  If you use a PS/2 keyboard (6 pin connector), say N here.
-
 config HPDCA
 	tristate "HP DCA serial support"
 	depends on DIO && SERIAL_8250

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

