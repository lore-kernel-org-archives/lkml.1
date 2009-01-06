Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZAFW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZAFW3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbZAFWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:06 -0500
Received: from kroah.org ([198.145.64.141]:51303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755722AbZAFWOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/60] i7300_idle: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:02 -0800
Message-Id: <1231279939-32728-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Andy Henroid <andrew.d.henroid@intel.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/idle/i7300_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/i7300_idle.c b/drivers/idle/i7300_idle.c
index fb176f6..17e8ddd 100644
--- a/drivers/idle/i7300_idle.c
+++ b/drivers/idle/i7300_idle.c
@@ -177,7 +177,7 @@ static int __init i7300_idle_ioat_selftest(u8 *ctl,
 }
 
 static struct device dummy_dma_dev = {
-	.bus_id = "fallback device",
+	.init_name = "fallback device",
 	.coherent_dma_mask = DMA_64BIT_MASK,
 	.dma_mask = &dummy_dma_dev.coherent_dma_mask,
 };
-- 
1.6.0.4

