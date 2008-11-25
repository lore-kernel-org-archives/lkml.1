Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYKYA6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYKYA6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYKYAzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:22 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57372 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 05/20] [MTD] Make the init_edb7312nor function static
Date: Tue, 25 Nov 2008 02:54:56 +0200
Message-Id: <1227574511-23879-6-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_edb7312nor function is needlessly defined global in
drivers/mtd/maps/edb7312.c, and this patch makes it static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/edb7312.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/edb7312.c b/drivers/mtd/maps/edb7312.c
index 9433738..be9e90b 100644
--- a/drivers/mtd/maps/edb7312.c
+++ b/drivers/mtd/maps/edb7312.c
@@ -71,7 +71,7 @@ static const char *probes[] = { "RedBoot", "cmdlinepart", NULL };
 static int                   mtd_parts_nb = 0;
 static struct mtd_partition *mtd_parts    = 0;
 
-int __init init_edb7312nor(void)
+static int __init init_edb7312nor(void)
 {
 	static const char *rom_probe_types[] = PROBETYPES;
 	const char **type;
-- 
1.5.3

