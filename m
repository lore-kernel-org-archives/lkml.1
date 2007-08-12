Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbXHLJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbXHLJpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbXHLJns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:43:48 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:56209 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbXHLJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:43:42 -0400
Message-Id: <20070812094117.830427206@mail.of.borg>
References: <20070812094050.522858761@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:40:53 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 03/10] m68k: Remove unnecessary m68k_memoffset export and init
Content-Disposition: inline; filename=unnecessary-m68k_memoffset.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Remove an unnecessary m68k_memoffset export and initialization

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -62,7 +62,6 @@ EXPORT_SYMBOL(m68k_num_memory);
 int m68k_realnum_memory;
 EXPORT_SYMBOL(m68k_realnum_memory);
 unsigned long m68k_memoffset;
-EXPORT_SYMBOL(m68k_memoffset);
 struct mem_info m68k_memory[NUM_MEMINFO];
 EXPORT_SYMBOL(m68k_memory);
 
@@ -200,7 +199,6 @@ static void __init m68k_parse_bootinfo(c
 		       (m68k_num_memory - 1));
 		m68k_num_memory = 1;
 	}
-	m68k_memoffset = m68k_memory[0].addr-PAGE_OFFSET;
 #endif
 }
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

