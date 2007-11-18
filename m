Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXKRKPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXKRKPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXKRKPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:18 -0500
Received: from agave.telenet-ops.be ([195.130.137.77]:43746 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXKRKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:15 -0500
Message-Id: <20071118101446.793269838@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:38 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alejandro Martinez Ruiz <alex@flawedcode.org>
Subject: [patch 02/13] dio: ARRAY_SIZE() cleanup
Content-Disposition: inline; filename=dio-ARRAY_SIZE-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alejandro Martinez Ruiz <alex@flawedcode.org>

dio: ARRAY_SIZE() cleanup

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/dio/dio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -88,7 +88,7 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
+#define NUMNAMES ARRAY_SIZE(names)
 
 static const char *unknowndioname 
         = "unknown DIO board -- please email <linux-m68k@lists.linux-m68k.org>!";

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

