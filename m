Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYDNOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYDNOY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbYDNOVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:11 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41961 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761130AbYDNOVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:07 -0400
Date: Mon, 14 Apr 2008 17:20:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtdram.c should #include <linux/mtd/mtdram.h>
Message-ID: <20080414142002.GQ6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global functions (in this case for mtdram_init_device()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
57fa07eda198d4f8a780000f99212ca7a83be2a1 diff --git a/drivers/mtd/devices/mtdram.c b/drivers/mtd/devices/mtdram.c
index e427c82..bf485ff 100644
--- a/drivers/mtd/devices/mtdram.c
+++ b/drivers/mtd/devices/mtdram.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/mtd/compatmac.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/mtdram.h>
 
 static unsigned long total_size = CONFIG_MTDRAM_TOTAL_SIZE;
 static unsigned long erase_size = CONFIG_MTDRAM_ERASE_SIZE;

