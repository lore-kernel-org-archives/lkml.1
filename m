Return-Path: <linux-kernel-owner+w=401wt.eu-S1765480AbXH0VcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765480AbXH0VcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764610AbXH0V2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58813 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765337AbXH0V2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:00 -0400
Date: Mon, 27 Aug 2007 23:28:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] unexport noautodma
Message-ID: <20070827212800.GR4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
> +ide-ide-remove-hwif-autodma-and-drive-autodma.patch
>...
>  IDE tree updates
>...

noautodma can now be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
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

