Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbXHOJwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbXHOJwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbXHOJuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:06 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:38278 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbXHOJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:56 -0400
Message-Id: <20070815094849.676579869@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:44 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 05/10] m68k: Remove unnecessary m68k_memoffset export and init
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

