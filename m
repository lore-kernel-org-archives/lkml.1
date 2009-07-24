Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbZGXFur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbZGXFur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 01:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZGXFur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 01:50:47 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:58423 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGXFuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 01:50:46 -0400
From: David John <davidjon@xenontk.org>
To: torvalds@linux-foundation.org
Cc: elendil@planet.nl, linux-kernel@vger.kernel.org, yinghai@kernel.org,
       jbarnes@virtuousgeek.org
Subject: Kind of like the following. Apply if you feel it is ok to _not_
Date: Fri, 24 Jul 2009 11:21:38 +0530
Message-Id: <1248414698-10072-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <4A6939F2.3050006@xenontk.org>
References: <4A6939F2.3050006@xenontk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

>From 645da858c547a6badd231e66003f58f32eb985a2 Mon Sep 17 00:00:00 2001
From: David John <davidjon@xenontk.org>
Date: Fri, 24 Jul 2009 10:36:15 +0530
Subject: [PATCH] Remove Spurious PnP Memory Reserved Warning

Remove unnecessary complaints about memory ranges being reserved by the
PnP sub-system.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 59b9092..feda64e 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -48,10 +48,6 @@ static void reserve_range(struct pnp_dev *dev, resource_size_t start,
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
-		port ? "ioport" : "iomem",
-		(unsigned long long) start, (unsigned long long) end,
-		res ? "has been" : "could not be");
 }
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)
