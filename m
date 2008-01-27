Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYA0Mg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYA0Mg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYA0MfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:03 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:54770 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbYA0Me5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:34:57 -0500
Message-Id: <20080127123356.403328763@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:19 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alejandro Martinez Ruiz <alex@flawedcode.org>
Subject: [patch 03/14] dio: ARRAY_SIZE() cleanup
Content-Disposition: inline; filename=dio-ARRAY_SIZE-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alejandro Martinez Ruiz <alex@flawedcode.org>

dio: ARRAY_SIZE() cleanup

[Geert: eliminate NUMNAMES, as suggested by Richard Knutsson ]

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/dio/dio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -88,8 +88,6 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
-
 static const char *unknowndioname 
         = "unknown DIO board -- please email <linux-m68k@lists.linux-m68k.org>!";
 
@@ -97,7 +95,7 @@ static const char *dio_getname(int id)
 {
         /* return pointer to a constant string describing the board with given ID */
 	unsigned int i;
-        for (i = 0; i < NUMNAMES; i++)
+        for (i = 0; i < ARRAY_SIZE(names); i++)
                 if (names[i].id == id) 
                         return names[i].name;
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

