Return-Path: <linux-kernel-owner+w=401wt.eu-S1762233AbXHOJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762233AbXHOJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbXHOJuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:03 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:60946 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbXHOJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:56 -0400
Message-Id: <20070815094849.414898023@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:43 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 04/10] m68k: Kill superfluous extern
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

