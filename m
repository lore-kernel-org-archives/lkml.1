Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYKYBAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYKYBAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYKYAza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:30 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57369 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbYKYAzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:16 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 15/20] [MTD] Make init_sbc8240_mtd function static
Date: Tue, 25 Nov 2008 02:55:06 +0200
Message-Id: <1227574511-23879-16-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function init_sbc8240_mtd is not called from outside the
module drivers/mtd/maps/sbc8240.c where it is defined, so it
can become static. Add the needed keyword.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/maps/sbc8240.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/sbc8240.c b/drivers/mtd/maps/sbc8240.c
index 6e1e99c..d5374cd 100644
--- a/drivers/mtd/maps/sbc8240.c
+++ b/drivers/mtd/maps/sbc8240.c
@@ -136,7 +136,7 @@ static struct mtd_part_def sbc8240_part_banks[NUM_FLASH_BANKS];
 #endif	/* CONFIG_MTD_PARTITIONS */
 
 
-int __init init_sbc8240_mtd (void)
+static int __init init_sbc8240_mtd (void)
 {
 	static struct _cjs {
 		u_long addr;
-- 
1.5.3

