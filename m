Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYDXVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYDXVSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYDXVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:18:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51934 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYDXVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:18:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Apr 2008 23:17:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: log scsi_target ID at release
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.478a048cc4090b07@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the good-by message more informative.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -784,7 +784,7 @@ static void sbp2_release_target(struct k
 		kfree(lu);
 	}
 	scsi_remove_host(shost);
-	fw_notify("released %s\n", tgt->bus_id);
+	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
 
 	fw_unit_put(tgt->unit);
 	scsi_host_put(shost);

-- 
Stefan Richter
-=====-==--- -=-- ==---
http://arcgraph.de/sr/

