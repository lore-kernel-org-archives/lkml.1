Return-Path: <linux-kernel-owner+w=401wt.eu-S1765767AbXGSXTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765767AbXGSXTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbXGSXTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:19:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXGSXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:19:32 -0400
Date: Fri, 20 Jul 2007 00:19:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fallout from [SPARC64]: Simplify VDC device probing
Message-ID: <20070719231931.GX21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	... hopefully that's what you meant here...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 2288b55..4ee3920 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -849,7 +849,7 @@ static struct vio_device_id vdc_port_match[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(vio, vdc_match);
+MODULE_DEVICE_TABLE(vio, vdc_port_match);
 
 static struct vio_driver vdc_port_driver = {
 	.id_table	= vdc_port_match,
diff --git a/drivers/net/sunvnet.c b/drivers/net/sunvnet.c
index b801e3b..ef0066b 100644
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1136,7 +1136,7 @@ static struct vio_device_id vnet_port_match[] = {
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(vio, vnet_match);
+MODULE_DEVICE_TABLE(vio, vnet_port_match);
 
 static struct vio_driver vnet_port_driver = {
 	.id_table	= vnet_port_match,
