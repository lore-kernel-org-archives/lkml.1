Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZAKTiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZAKTiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZAKTg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:36:29 -0500
Received: from mx1.suse.de ([195.135.220.2]:50646 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbZAKTg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:36:26 -0500
Message-Id: <21c150a6d2c39fe6975e91437095a2c31efdb550.1231695451.git.kkeil@suse.de>
In-Reply-To: <cover.1231695451.git.kkeil@suse.de>
References: <cover.1231695451.git.kkeil@suse.de>
Subject: [PATCH 6/7] misdn: indentation and braces disagree - add braces
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 16:24:49 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>,
       =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Date: Fri, 9 Jan 2009 12:22:52 -0800

This is not buggy due to plain luck as there is only one entry currently
in the element_attributes.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/dsp_pipeline.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 0c773fa..18cf87c 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -110,7 +110,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	}
 	list_add_tail(&entry->list, &dsp_elements);
 
-	for (i = 0; i < ARRAY_SIZE(element_attributes); ++i)
+	for (i = 0; i < ARRAY_SIZE(element_attributes); ++i) {
 		ret = device_create_file(&entry->dev,
 				&element_attributes[i]);
 		if (ret) {
@@ -118,6 +118,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 				__func__);
 			goto err2;
 		}
+	}
 
 #ifdef PIPELINE_DEBUG
 	printk(KERN_DEBUG "%s: %s registered\n", __func__, elem->name);
-- 
1.5.6.4

