Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbXEFUeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbXEFUeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbXEFUeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:34:00 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:44350 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbXEFUd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:33:59 -0400
Date: Sun, 6 May 2007 22:33:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: <asm/scatterlist.h> needs <asm/types.h>
Message-ID: <Pine.LNX.4.64.0705062233160.4741@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent <linux/pci.h> cleanup uncovered that include/asm-m68k/scatterlist.h
needs to include <asm/types.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/scatterlist.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-m68k-2.6.21.orig/include/asm-m68k/scatterlist.h
+++ linux-m68k-2.6.21/include/asm-m68k/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _M68K_SCATTERLIST_H
 #define _M68K_SCATTERLIST_H
 
+#include <asm/types.h>
+
 struct scatterlist {
 	struct page *page;
 	unsigned int offset;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
