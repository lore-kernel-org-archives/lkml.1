Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXIIU1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXIIU1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXIIUZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:25:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60729 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759478AbXIIUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:25:14 -0400
Date: Sun, 9 Sep 2007 22:25:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] unexport noautodma
Message-ID: <20070909202521.GR3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

noautodma can now be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 27 Aug 2007

957dc7601c050cb14a7afc842db0c2d62aaf3509 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index b3b5f00..5b09066 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -100,8 +100,6 @@ static int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
 
 int noautodma = 0;
 
-EXPORT_SYMBOL(noautodma);
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 int ide_noacpi = 0;
 int ide_noacpitfs = 1;

