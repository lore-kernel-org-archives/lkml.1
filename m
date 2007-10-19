Return-Path: <linux-kernel-owner+w=401wt.eu-S936711AbXJST6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936711AbXJST6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764585AbXJST6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:58:03 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:48184 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396AbXJST6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:58:01 -0400
Date: Fri, 19 Oct 2007 20:57:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz.h: Remove useless unused module junk
Message-ID: <Pine.LNX.4.64N.0710192055090.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove unused module function prototypes that would not even build if
enabled.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Please apply under the obviously-correct rule.

  Maciej

patch-mips-2.6.18-20060920-dz-junk-0
diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/drivers/serial/dz.h linux-mips-2.6.18-20060920/drivers/serial/dz.h
--- linux-mips-2.6.18-20060920.macro/drivers/serial/dz.h	2003-06-11 23:26:46.000000000 +0000
+++ linux-mips-2.6.18-20060920/drivers/serial/dz.h	2007-01-07 19:06:02.000000000 +0000
@@ -110,9 +110,4 @@
 #define DZ_XMIT_SIZE   4096                 /* buffer size */
 #define DZ_WAKEUP_CHARS   DZ_XMIT_SIZE/4
 
-#ifdef MODULE
-int init_module (void)
-void cleanup_module (void)
-#endif
-
 #endif /* DZ_SERIAL_H */
