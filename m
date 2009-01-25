Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbZAYW6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbZAYW6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZAYW6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:58:46 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:26099 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZAYW6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:58:46 -0500
Subject: serial: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:57:53 +0100
Message-Id: <1232924273.2924.23.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: serial: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: davem@davemloft.net
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/serial/sunzilog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1438,12 +1438,12 @@ static int __devinit zs_probe(struct of_
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


