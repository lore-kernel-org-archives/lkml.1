Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYDMSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYDMSRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYDMSQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:49 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42105 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYDMSQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:48 -0400
Date: Sun, 13 Apr 2008 21:15:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make __mmc_release_bus() static
Message-ID: <20080413181547.GG2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global __mmc_release_bus() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
383b3e66d17cbfd77a157e59983cb576a5a5259a diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index b966674..ab91b02 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -516,7 +516,7 @@ static void mmc_power_off(struct mmc_host *host)
 /*
  * Cleanup when the last reference to the bus operator is dropped.
  */
-void __mmc_release_bus(struct mmc_host *host)
+static void __mmc_release_bus(struct mmc_host *host)
 {
 	BUG_ON(!host);
 	BUG_ON(host->bus_refs);

