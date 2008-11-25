Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYKYA67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYKYA67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYKYAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:23 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57377 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYKYAzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:16 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 13/20] [MTD] Make init_redwood_flash function static
Date: Tue, 25 Nov 2008 02:55:04 +0200
Message-Id: <1227574511-23879-14-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_redwood_flash is needlessly defined global,
make it static by this patch.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/redwood.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/redwood.c b/drivers/mtd/maps/redwood.c
index de002eb..933c0b6 100644
--- a/drivers/mtd/maps/redwood.c
+++ b/drivers/mtd/maps/redwood.c
@@ -122,7 +122,7 @@ struct map_info redwood_flash_map = {
 
 static struct mtd_info *redwood_mtd;
 
-int __init init_redwood_flash(void)
+static int __init init_redwood_flash(void)
 {
 	int err;
 
-- 
1.5.3

