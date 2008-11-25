Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYKYA7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYKYA7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYKYAz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:26 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57371 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYKYAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:17 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 19/20] [MTD] Make the function init_vmax301 static
Date: Tue, 25 Nov 2008 02:55:10 +0200
Message-Id: <1227574511-23879-20-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_vmax301 is needlessly defined global in
drivers/mtd/maps/vmax301.c, and this patch makes it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/vmax301.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/vmax301.c b/drivers/mtd/maps/vmax301.c
index 5a0c9a3..6d452dc 100644
--- a/drivers/mtd/maps/vmax301.c
+++ b/drivers/mtd/maps/vmax301.c
@@ -146,7 +146,7 @@ static void __exit cleanup_vmax301(void)
 	iounmap((void *)vmax_map[0].map_priv_1 - WINDOW_START);
 }
 
-int __init init_vmax301(void)
+static int __init init_vmax301(void)
 {
 	int i;
 	unsigned long iomapadr;
-- 
1.5.3

