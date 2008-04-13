Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbYDMSSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbYDMSSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYDMSQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42206 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYDMSQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:50 -0400
Date: Sun, 13 Apr 2008 21:15:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototypes for mmc_attach_*()
Message-ID: <20080413181550.GH2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper prototypes for mmc_attach_*() in 
drivers/mmc/core/core.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mmc/core/core.c |    4 ----
 drivers/mmc/core/core.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

bb340d80c76a77876462f62612a0795ca21f2362 diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index ab91b02..01ced4c 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -35,10 +35,6 @@
 #include "sd_ops.h"
 #include "sdio_ops.h"
 
-extern int mmc_attach_mmc(struct mmc_host *host, u32 ocr);
-extern int mmc_attach_sd(struct mmc_host *host, u32 ocr);
-extern int mmc_attach_sdio(struct mmc_host *host, u32 ocr);
-
 static struct workqueue_struct *workqueue;
 
 /*
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index cfa8e15..cdb332b 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -46,6 +46,10 @@ void mmc_rescan(struct work_struct *work);
 void mmc_start_host(struct mmc_host *host);
 void mmc_stop_host(struct mmc_host *host);
 
+int mmc_attach_mmc(struct mmc_host *host, u32 ocr);
+int mmc_attach_sd(struct mmc_host *host, u32 ocr);
+int mmc_attach_sdio(struct mmc_host *host, u32 ocr);
+
 extern int use_spi_crc;
 
 #endif

