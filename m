Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXHLJoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXHLJoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXHLJnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:43:47 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:41152 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXHLJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:43:41 -0400
Message-Id: <20070812094117.538470431@mail.of.borg>
References: <20070812094050.522858761@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:40:52 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 02/10] m68k: Kill superfluous extern
Content-Disposition: inline; filename=630-extern-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kill a superfluous extern declaration

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/motorola.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -210,11 +210,7 @@ void __init paging_init(void)
 	int i;
 
 #ifdef DEBUG
-	{
-		extern unsigned long availmem;
-		printk ("start of paging_init (%p, %lx)\n",
-			kernel_pg_dir, availmem);
-	}
+	printk ("start of paging_init (%p, %lx)\n", kernel_pg_dir, availmem);
 #endif
 
 	/* Fix the cache mode in the page descriptors for the 680[46]0.  */

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

