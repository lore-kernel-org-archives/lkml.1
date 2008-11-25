Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYKYBCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYKYBCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYKYAzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:33 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57371 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 09/20] [MTD] Make ipaq_mtd_init function static
Date: Tue, 25 Nov 2008 02:55:00 +0200
Message-Id: <1227574511-23879-10-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol ipaq_mtd_init is not used anywhere outside of
drivers/mtd/maps/ipaq-flash.c, so make it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/ipaq-flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/ipaq-flash.c b/drivers/mtd/maps/ipaq-flash.c
index ed58f6a..748c85f 100644
--- a/drivers/mtd/maps/ipaq-flash.c
+++ b/drivers/mtd/maps/ipaq-flash.c
@@ -202,7 +202,7 @@ static const char *part_probes[] = { "cmdlinepart", "RedBoot", NULL };
 
 static int __init h1900_special_case(void);
 
-int __init ipaq_mtd_init(void)
+static int __init ipaq_mtd_init(void)
 {
 	struct mtd_partition *parts = NULL;
 	int nb_parts = 0;
-- 
1.5.3

