Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbXJMMgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbXJMMgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbXJMMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:35:34 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:35782 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbXJMMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:35:28 -0400
Message-Id: <20071013123413.168920487@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:27 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: [patch 4/8] m68k: Export cachectl.h
Content-Disposition: inline; filename=m68k-export-asm-cachectl-h.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

libffi in GCC 4.2 needs cachectl.h to do its cache flushing.  But we
don't currently export it.  I believe this patch should do the trick.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-m68k/Kbuild
+++ b/include/asm-m68k/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+header-y += cachectl.h

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

