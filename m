Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYKYA7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYKYA7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYKYAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:27 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57388 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbYKYAzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:17 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 18/20] [MTD] Make uclinux_mtd_cleanup and uclinux_mtd_init static
Date: Tue, 25 Nov 2008 02:55:09 +0200
Message-Id: <1227574511-23879-19-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions uclinux_mtd_cleanup and uclinux_mtd_init do
not heed to be global. Add the needed keyword to the file
drivers/mtd/maps/uclinux.c to make these functions static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/uclinux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index 0dc645f..81756e3 100644
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -51,7 +51,7 @@ int uclinux_point(struct mtd_info *mtd, loff_t from, size_t len,
 
 /****************************************************************************/
 
-int __init uclinux_mtd_init(void)
+static int __init uclinux_mtd_init(void)
 {
 	struct mtd_info *mtd;
 	struct map_info *mapp;
@@ -94,7 +94,7 @@ int __init uclinux_mtd_init(void)
 
 /****************************************************************************/
 
-void __exit uclinux_mtd_cleanup(void)
+static void __exit uclinux_mtd_cleanup(void)
 {
 	if (uclinux_ram_mtdinfo) {
 		del_mtd_partitions(uclinux_ram_mtdinfo);
-- 
1.5.3

