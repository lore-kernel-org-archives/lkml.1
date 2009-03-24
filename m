Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbZCXToH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbZCXToH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbZCXTnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:43:37 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:51499 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762731AbZCXTnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:43:35 -0400
Date: Tue, 24 Mar 2009 20:43:25 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>, Ilya Yanok <yanok@emcraft.com>
cc: netdev@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/dnet.c needs <linux/io.h>
Message-ID: <Pine.LNX.4.64.0903242042060.19647@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k:
| drivers/net/dnet.c: In function 'dnet_readw_mac':
| drivers/net/dnet.c:36: error: implicit declaration of function 'writel'
| drivers/net/dnet.c:43: error: implicit declaration of function 'readl'
| drivers/net/dnet.c: In function 'dnet_probe':
| drivers/net/dnet.c:873: error: implicit declaration of function 'ioremap'
| drivers/net/dnet.c:873: warning: assignment makes pointer from integer without a cast
| drivers/net/dnet.c:939: error: implicit declaration of function 'iounmap'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/dnet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/dnet.c b/drivers/net/dnet.c
index 1b40632..edf23c9 100644
--- a/drivers/net/dnet.c
+++ b/drivers/net/dnet.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/version.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-- 
1.6.2

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
