Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYFCRPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYFCRPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYFCROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:14:55 -0400
Received: from baikonur.stro.at ([213.239.196.228]:41048 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYFCROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:14:55 -0400
From: maximilian attems <max@stro.at>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, Amit Kucheria <amit.kucheria@ubuntu.com>,
       maximilian attems <max@stro.at>
Subject: [PATCH] add AGP support for Radeon Mobility 9000 chipset
Date: Tue,  3 Jun 2008 19:07:33 +0200
Message-Id: <1212512853-13506-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@ubuntu.com>

Bug: 178634

Signed-off-by: Amit Kucheria <amit.kucheria@ubuntu.com>
Signed-off-by: maximilian attems <max@stro.at>
---
 drivers/char/agp/ati-agp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 55c97f6..07b4d8f 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -458,6 +458,10 @@ static struct agp_device_ids ati_agp_device_ids[] __devinitdata =
 		.chipset_name	= "IGP9100/M",
 	},
 	{
+		.device_id	= PCI_DEVICE_ID_ATI_RS350_133,
+		.chipset_name	= "IGP9000/M",
+	},
+	{
 		.device_id	= PCI_DEVICE_ID_ATI_RS350_200,
 		.chipset_name	= "IGP9100/M",
 	},
-- 
1.5.5.1

