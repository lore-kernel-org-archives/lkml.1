Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZDOMP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZDOMP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZDOMPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:15:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZDOMPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:15:14 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "pierre@ossman.eu" <pierre@ossman.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Apr 2009 17:44:58 +0530
Subject: OMAP: MMC: Trivial fix for a typo in comment
Thread-Topic: OMAP: MMC: Trivial fix for a typo in comment
Thread-Index: Acm9w8umMgbiM6atQAS3vqrULNAGrA==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2517E2@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Gadiyar <gadiyar@ti.com>

OMAP: MMC: Trivial fix for a typo in comment

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
---
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index e62a22a..c40cb96 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -680,7 +680,7 @@ static void mmc_omap_dma_cb(int lch, u16 ch_status, void *data)
 	host->dma_ch = -1;
 	/*
 	 * DMA Callback: run in interrupt context.
-	 * mutex_unlock will through a kernel warning if used.
+	 * mutex_unlock will throw a kernel warning if used.
 	 */
 	up(&host->sem);
 }
