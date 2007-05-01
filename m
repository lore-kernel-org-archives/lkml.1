Return-Path: <linux-kernel-owner+w=401wt.eu-S1946002AbXEAUqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946002AbXEAUqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945918AbXEAUmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:42:15 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:36896 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423615AbXEAUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:56 -0400
Message-Id: <20070501203332.229877177@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:44 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       parisc-linux@parisc-linux.org
Subject: [patch 10/33] hilkbd: Kill compiler warning and fix comment dyslexia
Content-Disposition: inline; filename=hilkbd-warning.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hilkbd: Kill compiler warning and fix comment dyslexia

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/keyboard/hilkbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-m68k-2.6.21.orig/drivers/input/keyboard/hilkbd.c
+++ linux-m68k-2.6.21/drivers/input/keyboard/hilkbd.c
@@ -52,7 +52,7 @@ MODULE_LICENSE("GPL v2");
 
 #elif defined(CONFIG_HP300)
 
- #define HILBASE		0xf0428000 /* HP300 (m86k) port address */
+ #define HILBASE		0xf0428000UL /* HP300 (m68k) port address */
  #define HIL_DATA		0x1
  #define HIL_CMD		0x3
  #define HIL_IRQ		2

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

