Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbXKZIGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbXKZIGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbXKZIFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:05:51 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:44754 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbXKZIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:05:50 -0500
Date: Mon, 26 Nov 2007 09:05:44 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: zorro7xx needs <asm/amigahw.h>
Message-ID: <Pine.LNX.4.64.0711260904560.5800@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: zorro7xx needs <asm/amigahw.h> if !CONFIG_AMIGA_PCMCIA

Reported by Ingo Juergensmann <ij@2007.bluespice.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Please apply for 2.6.24.

 drivers/scsi/zorro7xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -13,7 +13,10 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/zorro.h>
+
+#include <asm/amigahw.h>
 #include <asm/amigaints.h>
+
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_spi.h>
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
