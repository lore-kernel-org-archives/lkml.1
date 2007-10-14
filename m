Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbXJNEu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbXJNEu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXJNEuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:50:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbXJNEuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:50:15 -0400
Date: Sun, 14 Oct 2007 05:50:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: [PATCH] typo in ibm_newemac/rgmii.c
Message-ID: <20071014045012.GS8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/ibm_newemac/rgmii.c b/drivers/net/ibm_newemac/rgmii.c
index bcd7fc6..3f57d6c 100644
--- a/drivers/net/ibm_newemac/rgmii.c
+++ b/drivers/net/ibm_newemac/rgmii.c
@@ -251,7 +251,7 @@ static int __devinit rgmii_probe(struct of_device *ofdev,
 	}
 
 	/* Check for RGMII type */
-	if (device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
+	if (of_device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
 		dev->type = RGMII_AXON;
 	else
 		dev->type = RGMII_STANDARD;
