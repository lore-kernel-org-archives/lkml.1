Return-Path: <linux-kernel-owner+w=401wt.eu-S1161386AbXD2VHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161386AbXD2VHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161383AbXD2VHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:07:51 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48236 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161339AbXD2VHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:07:35 -0400
Message-id: <1206432213194323666@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 21/21] Char: cyclades, copyright and version changes
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:07:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, copyright and version changes

- add copyright
- move version one number upper and use MODULE_VERSION

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 8f3cdfa90cfef76f4249331f4f6d7e06654f777d
tree d573fe3d21dde85e3aeb50233efa766b7d9f5bb1
parent c3f3dcbfe41732ece2f09a7c6e31e7a2b378a0f7
author Jiri Slaby <jirislaby@gmail.com> Sun, 29 Apr 2007 22:21:46 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 29 Apr 2007 22:21:46 +0200

 drivers/char/cyclades.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index a17ff90..ff961a3 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -10,15 +10,14 @@
  *
  * Initially written by Randolph Bentson <bentson@grieg.seaslug.org>.
  * Modified and maintained by Marcio Saito <marcio@cyclades.com>.
- * Currently maintained by Cyclades team <async@cyclades.com>.
  *
- * For Technical support and installation problems, please send e-mail
- * to support@cyclades.com.
+ * Copyright (C) 2007 Jiri Slaby <jirislaby@gmail.com>
  *
  * Much of the design and some of the code came from serial.c
  * which was copyright (C) 1991, 1992  Linus Torvalds.  It was
  * extensively rewritten by Theodore Ts'o, 8/16/92 -- 9/14/92,
  * and then fixed as suggested by Michael K. Johnson 12/12/92.
+ * Converted to pci probing and cleaned up by Jiri Slaby.
  *
  * This version supports shared IRQ's (only for PCI boards).
  *
@@ -591,7 +590,7 @@
  *
  */
 
-#define CY_VERSION	"2.4"
+#define CY_VERSION	"2.5"
 
 /* If you need to install more boards than NR_CARDS, change the constant
    in the definition below. No other change is necessary to support up to
@@ -5240,3 +5239,4 @@ module_init(cy_init);
 module_exit(cy_cleanup_module);
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION(CY_VERSION);
