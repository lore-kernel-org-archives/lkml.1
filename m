Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYERTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYERTBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761342AbYERSyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:00 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:55383 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761919AbYERSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:53:58 -0400
Message-Id: <20080518185150.779082752@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:10 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 04/18] m68k: Kill CONFIG_WHIPPET_SERIAL
Content-Disposition: inline; filename=m68k-whippet-serial-no-longer-exists.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The Hisoft Whippet PCMCIA serial driver has been removed a long time ago, but
it's Kconfig symbol still existed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -539,13 +539,6 @@ config AMIGA_BUILTIN_SERIAL
 
 	  To compile this driver as a module, choose M here.
 
-config WHIPPET_SERIAL
-	tristate "Hisoft Whippet PCMCIA serial support"
-	depends on AMIGA_PCMCIA
-	help
-	  HiSoft has a web page at <http://www.hisoft.co.uk/>, but there
-	  is no listing for the Whippet in their Amiga section.
-
 config MULTIFACE_III_TTY
 	tristate "Multiface Card III serial support"
 	depends on AMIGA

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

