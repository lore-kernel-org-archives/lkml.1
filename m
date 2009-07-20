Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbZGTBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbZGTBVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZGTBVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:21:37 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58712 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZGTBVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:21:36 -0400
Date: Sun, 19 Jul 2009 21:19:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: MTD mailing list <linux-mtd@lists.infradead.org>
Subject: [PATCH] MTD:  Correct typo "MTD_DATAFLASH_VERIFY_WRITE".
Message-ID: <alpine.LFD.2.00.0907192115420.18015@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the misspelling to match the actual config variable defined in
drivers/mtd/devi ces/Kconfig:

config MTD_DATAFLASH_WRITE_VERIFY
        bool "Verify DataFlash page writes"
        depends on MTD_DATAFLASH

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  you know, there's a *reason* i keep reporting these anomalies...

diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 43976aa..70a7369 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -401,7 +401,7 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 		(void) dataflash_waitready(priv->spi);


-#ifdef CONFIG_MTD_DATAFLASH_VERIFY_WRITE
+#ifdef CONFIG_MTD_DATAFLASH_WRITE_VERIFY

 		/* (3) Compare to Buffer1 */
 		addr = pageaddr << priv->page_offset;
@@ -430,7 +430,7 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 		} else
 			status = 0;

-#endif	/* CONFIG_MTD_DATAFLASH_VERIFY_WRITE */
+#endif	/* CONFIG_MTD_DATAFLASH_WRITE_VERIFY */

 		remaining = remaining - writelen;
 		pageaddr++;

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
