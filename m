Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXFCUyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXFCUyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXFCUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:53:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52689 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbXFCUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:53:58 -0400
Date: Sun, 3 Jun 2007 22:54:00 +0200
From: Adrian Bunk <bunk@stusta.de>
To: dwmw2@infradead.org, Mark Ferrell <mferrell@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [2.6 patch] remove dead MTD_PMC551_APERTURE_SIZE option
Message-ID: <20070603205359.GN5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_MTD_PMC551_APERTURE_SIZE option seems to never have existed, 
so there's no reason for carrying an #ifdef for it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc3-mm1/drivers/mtd/devices/pmc551.c.old	2007-06-03 19:16:00.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/mtd/devices/pmc551.c	2007-06-03 19:16:50.000000000 +0200
@@ -649,11 +649,7 @@
  * Stuff these outside the ifdef so as to not bust compiled in driver support
  */
 static int msize = 0;
-#if defined(CONFIG_MTD_PMC551_APERTURE_SIZE)
-static int asize = CONFIG_MTD_PMC551_APERTURE_SIZE;
-#else
 static int asize = 0;
-#endif
 
 module_param(msize, int, 0);
 MODULE_PARM_DESC(msize, "memory size in Megabytes [1 - 1024]");

