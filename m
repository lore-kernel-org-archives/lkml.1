Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbXHOJuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbXHOJuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbXHOJt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:49:56 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:60837 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXHOJtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:55 -0400
Message-Id: <20070815094848.609165650@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:40 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 01/10] m68k: <asm/page.h> needs <linux/compiler.h>
Content-Disposition: inline; filename=m68k-page.h-needs-compiler.h.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: <asm/page.h> needs <linux/compiler.h> because of __attribute_const__

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/page.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/asm-m68k/page.h
+++ b/include/asm-m68k/page.h
@@ -27,6 +27,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/compiler.h>
+
 #include <asm/module.h>
 
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

