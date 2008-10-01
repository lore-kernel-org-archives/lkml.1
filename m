Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYJAH54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYJAH54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYJAH5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:57:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYJAH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:57:39 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip] sdhci: 'scratch' may be used uninitialized
Date: Wed,  1 Oct 2008 00:57:26 -0700
Message-Id: <1222847847-7127-2-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index e3a8133..6257677 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -177,7 +177,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
 {
 	unsigned long flags;
 	size_t blksize, len, chunk;
-	u32 scratch;
+	u32 uninitialized_var(scratch);
 	u8 *buf;
 
 	DBG("PIO reading\n");
-- 
1.6.0.2

