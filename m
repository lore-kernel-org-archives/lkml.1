Return-Path: <linux-kernel-owner+w=401wt.eu-S933689AbZLOVCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689AbZLOVCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbZLOVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:02:14 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:45276 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649AbZLOVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:02:13 -0500
Date: Tue, 15 Dec 2009 22:02:09 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on
 CS5535_MFGPT
Message-ID: <alpine.DEB.2.00.0912152201380.4208@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 707c6b36fcf474c31f57a55fa983f3e1db59cf56 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Dec 2009 21:52:59 +0100
Subject: [PATCH] cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on CS5535_MFGPT

It doesn't make much sense to have CS5535_MFGPT_DEFAULT_IRQ show up in
configs that cannot have CS5535_MFGPT.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 59f4ba1..d4beee2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -203,6 +203,7 @@ config CS5535_MFGPT
 
 config CS5535_MFGPT_DEFAULT_IRQ
 	int
+	depends on CS5535_MFGPT
 	default 7
 	help
 	  MFGPTs on the CS5535 require an interrupt.  The selected IRQ
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
