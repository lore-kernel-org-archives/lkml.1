Return-Path: <linux-kernel-owner+w=401wt.eu-S1031460AbXD3IjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031460AbXD3IjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031469AbXD3IjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:39:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33937 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031460AbXD3IjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:39:04 -0400
X-Originating-Ip: 74.109.98.66
Date: Mon, 30 Apr 2007 04:38:56 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] I2O: Remove redundant GFP_KERNEL type flag in kmalloc().
Message-ID: <Pine.LNX.4.64.0704300437480.3703@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the apparently redundant GFP_KERNEL type flag in the call to
kmalloc().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index b9df143..8ef3ca4 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -485,7 +485,7 @@ int i2o_parm_field_get(struct i2o_device *i2o_dev, int group, int field,
 	u8 *resblk;		/* 8 bytes for header */
 	int rc;

-	resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
+	resblk = kmalloc(buflen + 8, GFP_ATOMIC);
 	if (!resblk)
 		return -ENOMEM;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
