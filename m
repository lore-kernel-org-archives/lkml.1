Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZAKThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZAKThK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZAKTg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:36:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:39327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZAKTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:36:25 -0500
Message-Id: <1916ebb2ddad78ae6405b1291acb9f9de212ec49.1231695451.git.kkeil@suse.de>
In-Reply-To: <cover.1231695451.git.kkeil@suse.de>
References: <cover.1231695451.git.kkeil@suse.de>
Subject: [PATCH 5/7] misdn: one handmade ARRAY_SIZE converted
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 16:24:43 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>,
       =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Date: Fri, 9 Jan 2009 12:22:51 -0800

Defined as:

static struct device_attribute element_attributes[] = {

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/dsp_pipeline.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index bf999bd..0c773fa 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -110,8 +110,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	}
 	list_add_tail(&entry->list, &dsp_elements);
 
-	for (i = 0; i < (sizeof(element_attributes)
-		/ sizeof(struct device_attribute)); ++i)
+	for (i = 0; i < ARRAY_SIZE(element_attributes); ++i)
 		ret = device_create_file(&entry->dev,
 				&element_attributes[i]);
 		if (ret) {
-- 
1.5.6.4

