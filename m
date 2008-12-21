Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYLUPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYLUPuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYLUPub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:50:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50563 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYLUPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:50:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Dec 2008 16:49:57 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: use list_first_entry
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.37153d3fa52fc6f9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -180,7 +180,7 @@ static int dequeue_event(struct client *
 		return -ENODEV;
 
 	spin_lock_irqsave(&client->lock, flags);
-	event = container_of(client->event_list.next, struct event, link);
+	event = list_first_entry(&client->event_list, struct event, link);
 	list_del(&event->link);
 	spin_unlock_irqrestore(&client->lock, flags);
 

-- 
Stefan Richter
-=====-==--- ==-- =-=-=
http://arcgraph.de/sr/

