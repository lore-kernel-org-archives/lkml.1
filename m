Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZBVMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZBVMSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZBVMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:18:14 -0500
Received: from cathcart.site5.com ([74.54.107.137]:43078 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbZBVMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:18:13 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH RESEND] spi_bfin5xx: remove unused IS_DMA_ALIGNED macro
Date: Sun, 22 Feb 2009 14:17:50 +0200
Message-Id: <1235305070-9224-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/spi/spi_bfin5xx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7fea3cf..abdbec9 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -35,8 +35,6 @@ MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_LICENSE("GPL");
 
-#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07) == 0)
-
 #define START_STATE	((void *)0)
 #define RUNNING_STATE	((void *)1)
 #define DONE_STATE	((void *)2)
-- 
1.5.6.4

