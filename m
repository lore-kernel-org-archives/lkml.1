Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYKYA5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYKYA5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYKYAzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:20 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57369 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbYKYAzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:15 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 08/20] [MTD] Make init_impa7 static
Date: Tue, 25 Nov 2008 02:54:59 +0200
Message-Id: <1227574511-23879-9-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_impa7 does not need to be global, and
this patch makes it static by adding the needed keyword
to drivers/mtd/maps/impa7.c.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/impa7.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/impa7.c b/drivers/mtd/maps/impa7.c
index 2682ab5..998a27d 100644
--- a/drivers/mtd/maps/impa7.c
+++ b/drivers/mtd/maps/impa7.c
@@ -70,7 +70,7 @@ static struct mtd_partition *mtd_parts[NUM_FLASHBANKS];
 
 static const char *probes[] = { "cmdlinepart", NULL };
 
-int __init init_impa7(void)
+static int __init init_impa7(void)
 {
 	static const char *rom_probe_types[] = PROBETYPES;
 	const char **type;
-- 
1.5.3

