Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbXGaSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbXGaSu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXGaSuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:50:15 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2001 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724AbXGaSuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:50:13 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 49] drivers/mmc/core/mmc_ops.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:50:13 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       drzeus-mmc@drzeus.cx
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312050.13687.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mmc/core/mmc_ops.c | 7957 -> 7924 (-33 bytes)
 drivers/mmc/core/mmc_ops.o | 101732 -> 101744 (+12 bytes)

 drivers/mmc/core/mmc_ops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/mmc/core/mmc_ops.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/mmc/core/mmc_ops.c	2007-07-30 00:20:54.000000000 +0200
@@ -298,10 +298,9 @@ int mmc_lock_unlock(struct mmc_card *car
 		data_size = 2 + mpayload->datalen;
 	}

-	data_buf = kmalloc(data_size, GFP_KERNEL);
+	data_buf = kzalloc(data_size, GFP_KERNEL);
 	if (!data_buf)
 		return -ENOMEM;
-	memset(data_buf, 0, data_size);

 	data_buf[0] |= mode;
 	if (mode & MMC_LOCK_MODE_UNLOCK)
