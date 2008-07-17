Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbYGQTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbYGQTcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbYGQTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:29 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:35534 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833AbYGQTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:47 -0400
Message-Id: <20080717191753.579132620@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:22 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 15/29] export c2p
Content-Disposition: inline; filename=m68k-export-c2p.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following build error:

<--  snip  -->

..
  Building modules, stage 2.
  MODPOST 1203 modules
ERROR: "c2p" [drivers/video/amifb.ko] undefined!
..
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -227,5 +227,6 @@ void c2p(u8 *dst, const u8 *src, u32 dx,
 	dst += dst_nextline;
     }
 }
+EXPORT_SYMBOL_GPL(c2p);
 
 MODULE_LICENSE("GPL");

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

