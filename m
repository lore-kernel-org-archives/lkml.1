Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZGXGKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZGXGKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 02:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZGXGKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 02:10:23 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:47726 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZGXGKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 02:10:23 -0400
From: David John <davidjon@xenontk.org>
To: torvalds@linux-foundation.org
Cc: elendil@planet.nl, linux-kernel@vger.kernel.org, yinghai@kernel.org,
       jbarnes@virtuousgeek.org
Subject: [PATCH] Remove Spurious PnP Memory Reserved Warning
Date: Fri, 24 Jul 2009 11:41:23 +0530
Message-Id: <1248415883-11809-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <200907240953.48297.elendil@planet.nl>
References: <200907240953.48297.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 645da858c547a6badd231e66003f58f32eb985a2 Mon Sep 17 00:00:00 2001
From: David John <davidjon@xenontk.org>
Date: Fri, 24 Jul 2009 10:36:15 +0530
Subject: [PATCH] Remove Spurious PnP Memory Reserved Warning

I'd rather you just remove it. Kind of like the following.
Apply if you feel it is ok to _not_ print these messages...
(Sorry for the previous mangled one...)

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
