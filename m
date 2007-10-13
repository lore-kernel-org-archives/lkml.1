Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbXJMMhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbXJMMhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbXJMMfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:35:39 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:55428 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbXJMMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:35:30 -0400
Message-Id: <20071013123414.647276232@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:31 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [patch 8/8] ssb bus needs <linux/io.h>
Content-Disposition: inline; filename=ssb-needs-linux-io.h.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ssb bus needs <linux/io.h>

linux/drivers/ssb/main.c: In function 'ssb_ssb_read16':
linux/drivers/ssb/main.c:518: error: implicit declaration of function 'readw'
linux/drivers/ssb/main.c: In function 'ssb_ssb_read32':
linux/drivers/ssb/main.c:526: error: implicit declaration of function 'readl'
linux/drivers/ssb/main.c: In function 'ssb_ssb_write16':
linux/drivers/ssb/main.c:534: error: implicit declaration of function 'writew'
linux/drivers/ssb/main.c: In function 'ssb_ssb_write32':
linux/drivers/ssb/main.c:542: error: implicit declaration of function 'writel'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/ssb/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -11,6 +11,7 @@
 #include "ssb_private.h"
 
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_regs.h>
 #include <linux/dma-mapping.h>

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

