Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYFOTth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYFOTth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFOTta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:49:30 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:54064 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069AbYFOTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:49:29 -0400
X-Trace: 28759215/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.82.193
X-SBRS: None
X-RemoteIP: 81.1.82.193
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAIIPVUhRAVLB/2dsb2JhbACBW6ob
X-IronPort-AV: E=Sophos;i="4.27,648,1204502400"; 
   d="scan'208";a="28759215"
Subject: [PATCH] maple: tidy  maple_driver code by removing redundant
	connect/disconnect
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 20:48:09 +0100
Message-Id: <1213559289.22707.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The connect and disconnect functions are unnecessary - everything they do can be
accomplished in the initial probe - so remove them.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/include/linux/maple.h b/include/linux/maple.h
index 39a125a..d49e2d3 100644
--- a/include/linux/maple.h
+++ b/include/linux/maple.h
@@ -62,8 +62,6 @@ struct maple_device {
 
 struct maple_driver {
 	unsigned long function;
-	int (*connect) (struct maple_device * dev);
-	void (*disconnect) (struct maple_device * dev);
 	struct device_driver drv;
 };

