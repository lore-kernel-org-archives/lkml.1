Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbYDKR3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbYDKR3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759031AbYDKR31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:29:27 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46032 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbYDKR30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:29:26 -0400
Date: Fri, 11 Apr 2008 20:28:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ali_atapi_dma static
Message-ID: <20080411172827.GC25788@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global ali_atapi_dma static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
de012fdf57e025cf243181cb3fce87f890ccc955 diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index ce830fe..511a830 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -36,7 +36,7 @@
 #define DRV_NAME "pata_ali"
 #define DRV_VERSION "0.7.5"
 
-int ali_atapi_dma = 0;
+static int ali_atapi_dma = 0;
 module_param_named(atapi_dma, ali_atapi_dma, int, 0644);
 MODULE_PARM_DESC(atapi_dma, "Enable ATAPI DMA (0=disable, 1=enable)");
 

