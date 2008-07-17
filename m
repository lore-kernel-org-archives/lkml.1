Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbYGQTaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbYGQTaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbYGQTXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:08 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:50784 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbYGQTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:52 -0400
Message-Id: <20080717191756.953848306@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:32 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 25/29] m68k/Apollo: remove the unused APOLLO_ELPLUS option
Content-Disposition: inline; filename=m68k-apollo-remove-the-unused-APOLLO_ELPLUS-option.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at older kernel sources the APOLLO_ELPLUS option was added 
somewhere during kernel 2.1, but even kernel 2.2.0 does not contain
any driver that would be enabled through it...

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -333,15 +333,6 @@ config APNE
 	  To compile this driver as a module, choose M here: the module
 	  will be called apne.
 
-config APOLLO_ELPLUS
-	tristate "Apollo 3c505 support"
-	depends on APOLLO
-	help
-	  Say Y or M here if your Apollo has a 3Com 3c505 ISA Ethernet card.
-	  If you don't have one made for Apollos, you can use one from a PC,
-	  except that your Apollo won't be able to boot from it (because the
-	  code in the ROM will be for a PC).
-
 config MAC8390
 	bool "Macintosh NS 8390 based ethernet cards"
 	depends on MAC

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

