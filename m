Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbXKRKQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbXKRKQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXKRKPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:21 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:37810 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXKRKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:15 -0500
Message-Id: <20071118101446.579488651@mail.of.borg>
References: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:37 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Alejandro Martinez Ruiz <alex@flawedcode.org>
Subject: [patch 01/13] m68k: ARRAY_SIZE() cleanup
Content-Disposition: inline; filename=m68k-ARRAY_SIZE-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alejandro Martinez Ruiz <alex@flawedcode.org>

m68k: ARRAY_SIZE() cleanup

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/amisound.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/amiga/amisound.c
+++ b/arch/m68k/amiga/amisound.c
@@ -21,7 +21,7 @@ static const signed char sine_data[] = {
 	0,  39,  75,  103,  121,  127,  121,  103,  75,  39,
 	0, -39, -75, -103, -121, -127, -121, -103, -75, -39
 };
-#define DATA_SIZE	(sizeof(sine_data)/sizeof(sine_data[0]))
+#define DATA_SIZE	ARRAY_SIZE(sine_data)
 
 #define custom amiga_custom
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

