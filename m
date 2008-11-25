Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYKYBAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYKYBAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYKYAz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:28 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57389 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbYKYAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:17 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 17/20] [MTD] Make init_tqm_mtd function static
Date: Tue, 25 Nov 2008 02:55:08 +0200
Message-Id: <1227574511-23879-18-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_tqm_mtd function does not need to be defined globally
in drivers/mtd/maps/tqm8xxl.c. Make it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/tqm8xxl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/tqm8xxl.c b/drivers/mtd/maps/tqm8xxl.c
index a5d3d85..6014698 100644
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -109,7 +109,7 @@ static struct mtd_partition tqm8xxl_fs_partitions[] = {
 };
 #endif
 
-int __init init_tqm_mtd(void)
+static int __init init_tqm_mtd(void)
 {
 	int idx = 0, ret = 0;
 	unsigned long flash_addr, flash_size, mtd_size = 0;
-- 
1.5.3

