Return-Path: <linux-kernel-owner+w=401wt.eu-S1945900AbXEAUmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945900AbXEAUmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423654AbXEAUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:42:07 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:45656 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423619AbXEAUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:57 -0400
Message-Id: <20070501203333.132238513@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:47 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Creasey <sammy@sammy.net>
Subject: [patch 13/33] m68k: Correct number of interrupts for Sun3
Content-Disposition: inline; filename=sun3-numints.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Creasey <sammy@sammy.net>

Only attempt to initialize the amount of interrupts a sun3 actually has...

Signed-off-by: Sam Creasey <sammy@sammy.net>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/sun3/sun3ints.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-m68k-2.6.21.orig/arch/m68k/sun3/sun3ints.c
+++ linux-m68k-2.6.21/arch/m68k/sun3/sun3ints.c
@@ -103,7 +103,7 @@ void sun3_init_IRQ(void)
 
 	m68k_setup_auto_interrupt(sun3_inthandle);
 	m68k_setup_irq_controller(&sun3_irq_controller, IRQ_AUTO_1, 7);
-	m68k_setup_user_interrupt(VEC_USER, 192, NULL);
+	m68k_setup_user_interrupt(VEC_USER, 128, NULL);
 
 	request_irq(IRQ_AUTO_5, sun3_int5, 0, "int5", NULL);
 	request_irq(IRQ_AUTO_7, sun3_int7, 0, "int7", NULL);

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

