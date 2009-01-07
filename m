Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZAGLd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZAGLd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZAGLdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:33:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:37252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZAGLdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:33:16 -0500
Date: Wed, 7 Jan 2009 12:33:15 +0100
From: Karsten Keil <kkeil@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 41/60] ISDN: struct device - replace bus_id with dev_name(), dev_set_name()
Message-ID: <20090107113315.GB25205@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106221123.GA32689@kroah.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
X-Mailer: git-send-email 1.6.0.4
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Karsten Keil <kkeil@suse.de>
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

