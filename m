Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYKYA6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYKYA6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYKYAzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:25 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57368 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbYKYAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:17 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 16/20] [MTD] Make init_sharpsl symbol static
Date: Tue, 25 Nov 2008 02:55:07 +0200
Message-Id: <1227574511-23879-17-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_sharpsl is needlessly defined global.
Make it static by adding the needed keyword to the file
drivers/mtd/maps/sharpsl-flash.c, where the function is
defined.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/sharpsl-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/sharpsl-flash.c b/drivers/mtd/maps/sharpsl-flash.c
index 026eab0..b392f09 100644
--- a/drivers/mtd/maps/sharpsl-flash.c
+++ b/drivers/mtd/maps/sharpsl-flash.c
@@ -47,7 +47,7 @@ static struct mtd_partition sharpsl_partitions[1] = {
 	}
 };
 
-int __init init_sharpsl(void)
+static int __init init_sharpsl(void)
 {
 	struct mtd_partition *parts;
 	int nb_parts = 0;
-- 
1.5.3

