Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZCYAd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZCYAd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZCYA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:43 -0400
Received: from kroah.org ([198.145.64.141]:54058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755995AbZCYA3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, davem@davemloft.net
Subject: [PATCH 10/61] serial: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:14 -0700
Message-Id: <1237940825-22904-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: davem@davemloft.net
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/serial/sunzilog.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index 45a299f..e09d3ce 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1438,12 +1438,12 @@ static int __devinit zs_probe(struct of_device *op, const struct of_device_id *m
 	} else {
 		printk(KERN_INFO "%s: Keyboard at MMIO 0x%llx (irq = %d) "
 		       "is a %s\n",
-		       op->dev.bus_id,
+		       dev_name(&op->dev),
 		       (unsigned long long) up[0].port.mapbase,
 		       op->irqs[0], sunzilog_type(&up[0].port));
 		printk(KERN_INFO "%s: Mouse at MMIO 0x%llx (irq = %d) "
 		       "is a %s\n",
-		       op->dev.bus_id,
+		       dev_name(&op->dev),
 		       (unsigned long long) up[1].port.mapbase,
 		       op->irqs[0], sunzilog_type(&up[1].port));
 		kbm_inst++;
-- 
1.6.2

