Return-Path: <linux-kernel-owner+w=401wt.eu-S1945968AbXEAUnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968AbXEAUnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945967AbXEAUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:43:04 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:45629 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423602AbXEAUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:53 -0400
Message-Id: <20070501203330.778353898@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:40 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 06/33] m68k: CROSS_COMPILE = m68k-linux-gnu-
Content-Disposition: inline; filename=m68k-linux-gnu-crosscompile.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent cross-compilers are called m68k-linux-gnu-gcc instead of m68k-linux-gcc

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-m68k-2.6.21.orig/arch/m68k/Makefile
+++ linux-m68k-2.6.21/arch/m68k/Makefile
@@ -21,7 +21,7 @@ AS += -m68020
 LDFLAGS := -m m68kelf
 ifneq ($(COMPILE_ARCH),$(ARCH))
 	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-
+	CROSS_COMPILE = m68k-linux-gnu-
 endif
 
 ifdef CONFIG_SUN3

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

