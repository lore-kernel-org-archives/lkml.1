Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYKYAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYKYAz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYKYAzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:15 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57317 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYKYAzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:14 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 02/20] [MTD] Make alchemy_mtd_init function static
Date: Tue, 25 Nov 2008 02:54:53 +0200
Message-Id: <1227574511-23879-3-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol alchemy_mtd_init does not need to be global, so make it
static in drivers/mtd/maps/alchemy-flash.c.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/alchemy-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/alchemy-flash.c b/drivers/mtd/maps/alchemy-flash.c
index 82811bc..845ad4f 100644
--- a/drivers/mtd/maps/alchemy-flash.c
+++ b/drivers/mtd/maps/alchemy-flash.c
@@ -111,7 +111,7 @@ static struct mtd_partition alchemy_partitions[] = {
 
 static struct mtd_info *mymtd;
 
-int __init alchemy_mtd_init(void)
+static int __init alchemy_mtd_init(void)
 {
 	struct mtd_partition *parts;
 	int nb_parts = 0;
-- 
1.5.3

