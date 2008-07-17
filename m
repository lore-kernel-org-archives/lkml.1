Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbYGQTca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbYGQTca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbYGQTXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:30 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:34888 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759824AbYGQTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:47 -0400
Message-Id: <20080717191753.310200688@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:21 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 14/29] export amiga_vblank
Content-Disposition: inline; filename=m68k-export-amiga_vblank.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following build error:

<--  snip  -->

..
  Building modules, stage 2.
  MODPOST 1203 modules
ERROR: "amiga_vblank" [drivers/video/amifb.ko] undefined!
..
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/config.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -51,6 +51,8 @@ unsigned long amiga_chipset;
 EXPORT_SYMBOL(amiga_chipset);
 
 unsigned char amiga_vblank;
+EXPORT_SYMBOL(amiga_vblank);
+
 unsigned char amiga_psfreq;
 
 struct amiga_hw_present amiga_hw_present;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

