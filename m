Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYLNUpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYLNUpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYLNUpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:45:24 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38698 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYLNUpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:45:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 21:45:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firewire: core: remove obsolete assertions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
Message-ID: <tkrat.bcdb0c670c8884a7@s5r6.in-berlin.de>
References: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code never changes.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -955,19 +955,10 @@ static int __init fw_core_init(void)
 		return fw_cdev_major;
 	}
 
-	retval = fw_core_add_address_handler(&topology_map,
-					     &topology_map_region);
-	BUG_ON(retval < 0);
-
-	retval = fw_core_add_address_handler(&registers,
-					     &registers_region);
-	BUG_ON(retval < 0);
-
-	/* Add the vendor textual descriptor. */
-	retval = fw_core_add_descriptor(&vendor_id_descriptor);
-	BUG_ON(retval < 0);
-	retval = fw_core_add_descriptor(&model_id_descriptor);
-	BUG_ON(retval < 0);
+	fw_core_add_address_handler(&topology_map, &topology_map_region);
+	fw_core_add_address_handler(&registers, &registers_region);
+	fw_core_add_descriptor(&vendor_id_descriptor);
+	fw_core_add_descriptor(&model_id_descriptor);
 
 	return 0;
 }

-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

