Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbYEETQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbYEETQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbYEETQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:16:17 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:40501 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762338AbYEETQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:16:15 -0400
Date: Mon, 5 May 2008 21:16:13 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <matthew@wil.cx>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: drivers/input/serio/hp_sdc.c needs <linux/semaphore.h>
Message-ID: <Pine.LNX.4.64.0805052115500.18749@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/input/serio/hp_sdc.c: In function 'hp_sdc_take':
drivers/input/serio/hp_sdc.c:198: error: implicit declaration of function 'up'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/serio/hp_sdc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -69,6 +69,7 @@
 #include <linux/time.h>
 #include <linux/slab.h>
 #include <linux/hil.h>
+#include <linux/semaphore.h>
 #include <asm/io.h>
 #include <asm/system.h>
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
