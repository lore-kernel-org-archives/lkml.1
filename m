Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZAFW2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZAFW2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZAFWOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:03 -0500
Received: from kroah.org ([198.145.64.141]:51297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756026AbZAFWOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Karsten Keil <kkeil@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/60] ISDN: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:00 -0800
Message-Id: <1231279939-32728-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Karsten Keil <kkeil@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/isdn/mISDN/dsp_pipeline.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 5ee6651..83639be 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -91,7 +91,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 
 	entry->dev.class = elements_class;
 	dev_set_drvdata(&entry->dev, elem);
-	snprintf(entry->dev.bus_id, BUS_ID_SIZE, elem->name);
+	dev_set_name(&entry->dev, elem->name);
 	ret = device_register(&entry->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register %s\n",
-- 
1.6.0.4

