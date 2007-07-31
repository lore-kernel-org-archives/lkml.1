Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbXGaV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbXGaV3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbXGaV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:29:17 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2199 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbXGaV3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:29:15 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 56] drivers/scsi/NCR_D700.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:29:15 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312329.15766.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/NCR_D700.c | 10643 -> 10615 (-28 bytes)
 drivers/scsi/NCR_D700.o | 118400 -> 118196 (-204 bytes)

 drivers/scsi/NCR_D700.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/NCR_D700.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/NCR_D700.c	2007-07-31 11:13:37.000000000 +0200
@@ -313,10 +313,10 @@ NCR_D700_probe(struct device *dev)
 		break;
 	}

-	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	memset(p, '\0', sizeof(*p));
+
 	p->dev = dev;
 	snprintf(p->name, sizeof(p->name), "D700(%s)", dev->bus_id);
 	if (request_irq(irq, NCR_D700_intr, IRQF_SHARED, p->name, p)) {
