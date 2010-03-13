Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab0CMOzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:55:45 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56329 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab0CMOzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GMtixVNw1ix7j2QRRCDrydu+Tysdmk5gVJ5BlAeQ9pWCaCWX6LmANvsr8Xu4MENNdB
         3TAAdxYODGxGYsV2A8QW7ffS+iKy/IFiLAoiWFBhFFOubChABTBtNOGW4yjjrp+oqYs+
         j8uP/yFvWdCxVXARRsiIAXhAvH5mVy0paazco=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 7/9] Staging: comedi: cb_das16_cs: fixed multiple brace coding style issue
Date: Sat, 13 Mar 2010 22:53:32 +0800
Message-Id: <1268492014-6355-8-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index bc375e7..bf8271f 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -174,16 +174,16 @@ static int das16cs_attach(struct comedi_device *dev,
 	printk("I/O base=0x%04lx ", dev->iobase);
 
 	printk("fingerprint:\n");
-	for (i = 0; i < 48; i += 2) {
+	for (i = 0; i < 48; i += 2)
 		printk("%04x ", inw(dev->iobase + i));
-	}
+
 	printk("\n");
 
 	ret = request_irq(link->irq.AssignedIRQ, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
-	if (ret < 0) {
+	if (ret < 0)
 		return ret;
-	}
+
 	dev->irq = link->irq.AssignedIRQ;
 	printk("irq=%u ", dev->irq);
 
@@ -261,9 +261,9 @@ static int das16cs_detach(struct comedi_device *dev)
 {
 	printk("comedi%d: das16cs: remove\n", dev->minor);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
 
 	return 0;
 }
-- 
1.7.0

