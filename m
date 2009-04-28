Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZD1TUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZD1TUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZD1TU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:20:26 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:51308 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZD1TUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:20:25 -0400
Date: Tue, 28 Apr 2009 21:20:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Tim Abbott <tabbott@mit.edu>
cc: Sam Ravnborg <sam@ravnborg.org>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: arch/m68k/kernel/sun3-head.S needs <linux/init.h>
Message-ID: <Pine.LNX.4.64.0904282118330.14413@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| arch/m68k/kernel/sun3-head.S: Assembler messages:
| arch/m68k/kernel/sun3-head.S:32: Error: Unknown operator -- statement `__head' ignored

Introduced by commit 6f335cab0431d5df4995bcd4fd952d4c746d5a86 ("m68k: convert
to use __HEAD and HEAD_TEXT macros."), which started using __HEAD without
adding the appropriate include.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Can we please run `trivial' changes through linux-next too, please? Thx!

 arch/m68k/kernel/sun3-head.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/kernel/sun3-head.S b/arch/m68k/kernel/sun3-head.S
index 9e5c3e5..43036bf 100644
--- a/arch/m68k/kernel/sun3-head.S
+++ b/arch/m68k/kernel/sun3-head.S
@@ -1,4 +1,5 @@
 #include <linux/linkage.h>
+#include <linux/init.h>
 
 #include <asm/entry.h>
 #include <asm/page.h>
-- 
1.6.2.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
