Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbXLKEdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbXLKEdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXLKEdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:33:03 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39773 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbXLKEdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:33:00 -0500
Date: Tue, 11 Dec 2007 05:32:48 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071211043423.28518.72145.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 3/6] pcmcia/axnet_cs: Make functions static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   drivers/net/pcmcia/axnet_cs.c
drivers/net/pcmcia/axnet_cs.c:994:5: warning: symbol 'ax_close' was not declared. Should it be static?
drivers/net/pcmcia/axnet_cs.c:1017:6: warning: symbol 'ei_tx_timeout' was not declared. Should it be static?

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---


diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 8d910a3..96931cc 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -991,7 +991,7 @@ static int ax_open(struct net_device *dev)
  *
  * Opposite of ax_open(). Only used when "ifconfig <devname> down" is done.
  */
-int ax_close(struct net_device *dev)
+static int ax_close(struct net_device *dev)
 {
 	unsigned long flags;
 
@@ -1014,7 +1014,7 @@ int ax_close(struct net_device *dev)
  * completed (or failed) - i.e. never posted a Tx related interrupt.
  */
 
-void ei_tx_timeout(struct net_device *dev)
+static void ei_tx_timeout(struct net_device *dev)
 {
 	long e8390_base = dev->base_addr;
 	struct ei_device *ei_local = (struct ei_device *) netdev_priv(dev);
