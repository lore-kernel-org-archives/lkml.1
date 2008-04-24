Return-Path: <linux-kernel-owner+w=401wt.eu-S1762430AbYDXSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbYDXSgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYDXSeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:22 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:40293 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYDXSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:15 -0400
Message-Id: <20080424183241.755828089@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:45 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/15] m68k vme_scc: avoid global namespace pollution
Content-Disposition: inline; filename=m68k-vme_scc-globals.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k vme_scc:
  - make scc_ports[] static
  - kill unused global scc_initialized

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/vme_scc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/vme_scc.c
+++ b/drivers/char/vme_scc.c
@@ -89,9 +89,7 @@ static void scc_break_ctl(struct tty_str
 
 static struct tty_driver *scc_driver;
 
-struct scc_port scc_ports[2];
-
-int scc_initialized = 0;
+static struct scc_port scc_ports[2];
 
 /*---------------------------------------------------------------------------
  * Interface from generic_serial.c back here

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

