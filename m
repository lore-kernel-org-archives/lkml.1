Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbXKRKTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbXKRKTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbXKRKPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:40 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:37842 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXKRKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:20 -0500
Message-Id: <20071118101449.599255536@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:49 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>
Subject: [patch 13/13] mac68k: remove dead MAC_ADBKEYCODES
Content-Disposition: inline; filename=mac68k-remove-dead-MAC_ADBKEYCODES.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Brabec <sbrabec@suse.cz>

It seems, that current kernel source code contains no traces of
MAC_ADBKEYCODES and no reference to keyboard_sends_linux_keycodes any
more.

Attached patch removes them from configuration files.

Signed-off-by: Stanislav Brabec <sbrabec@suse.cz>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig               |   14 --------------
 arch/m68k/configs/mac_defconfig |    1 -
 2 files changed, 15 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -582,20 +582,6 @@ config MAC_HID
 	depends on INPUT_ADBHID
 	default y
 
-config MAC_ADBKEYCODES
-	bool "Support for ADB raw keycodes"
-	depends on INPUT_ADBHID
-	help
-	  This provides support for sending raw ADB keycodes to console
-	  devices.  This is the default up to 2.4.0, but in future this may be
-	  phased out in favor of generic Linux keycodes.  If you say Y here,
-	  you can dynamically switch via the
-	  /proc/sys/dev/mac_hid/keyboard_sends_linux_keycodes
-	  sysctl and with the "keyboard_sends_linux_keycodes=" kernel
-	  argument.
-
-	  If unsure, say Y here.
-
 config ADB_KEYBOARD
 	bool "Support for ADB keyboard (old driver)"
 	depends on MAC && !INPUT_ADBHID
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -678,7 +678,6 @@ CONFIG_LOGO_MAC_CLUT224=y
 #
 CONFIG_MAC_SCC=y
 CONFIG_MAC_HID=y
-CONFIG_MAC_ADBKEYCODES=y
 CONFIG_SERIAL_CONSOLE=y
 
 #

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

