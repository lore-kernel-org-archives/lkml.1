Return-Path: <linux-kernel-owner+w=401wt.eu-S1946569AbXBIQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946569AbXBIQG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946601AbXBIQFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53640 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946582AbXBIQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:37 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] m32r: class_device -> device fallout
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYFl-0004sP-1N@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/pcmcia/m32r_pcc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index bbf0258..4dbef07 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -722,7 +722,7 @@ static int __init init_m32r_pcc(void)
 	/* Set up interrupt handler(s) */
 
 	for (i = 0 ; i < pcc_sockets ; i++) {
-		socket[i].socket.dev.dev = &pcc_device.dev;
+		socket[i].socket.dev.parent = &pcc_device.dev;
 		socket[i].socket.ops = &pcc_operations;
 		socket[i].socket.resource_ops = &pccard_static_ops;
 		socket[i].socket.owner = THIS_MODULE;
-- 
1.5.0-rc2.GIT


