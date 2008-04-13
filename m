Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYDMSSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYDMSSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYDMSQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:53 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54166 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbYDMSQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:53 -0400
Date: Sun, 13 Apr 2008 21:15:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mmc/core/sdio_ops.c should #include "sdio_ops.h"
Message-ID: <20080413181552.GI2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
74cc02b17c51b27632b49e7092ba4f79ff6f2f26 diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index e1fca58..c8fa095 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -17,6 +17,7 @@
 #include <linux/mmc/sdio.h>
 
 #include "core.h"
+#include "sdio_ops.h"
 
 int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 {

