Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbYGQTdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbYGQTdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbYGQTXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:37 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:50759 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682AbYGQTWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:46 -0400
Message-Id: <20080717191753.038486596@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:20 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 13/29] drivers/video/c2p.c: add MODULE_LICENSE
Content-Disposition: inline; filename=drivers-video-c2p.c-add-MODULE_LICENSE.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch adds the missing MODULE_LICENSE("GPL").

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -12,6 +12,7 @@
  *  for more details.
  */
 
+#include <linux/module.h>
 #include <linux/string.h>
 #include "c2p.h"
 
@@ -227,3 +228,4 @@ void c2p(u8 *dst, const u8 *src, u32 dx,
     }
 }
 
+MODULE_LICENSE("GPL");

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

