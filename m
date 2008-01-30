Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbYA3OTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbYA3OTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbYA3OSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:18:49 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:46266 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246AbYA3OSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:18:46 -0500
Message-ID: <47A08740.3020708@tiscali.nl>
Date: Wed, 30 Jan 2008 15:18:40 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: tnt@246tNt.com, grant.likely@secretlab.ca
CC: linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/net/fec_mpc52xx.c] duplicate NETIF_MSG_IFDOWN in
 MPC52xx_MESSAGES_DEFAULT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested patch below, please confirm it's the right fix.
--
duplicate NETIF_MSG_IFDOWN, 2nd should be NETIF_MSG_IFUP

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index f91ee70..ca3c3b3 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -55,7 +55,7 @@ module_param_array_named(mac, mpc52xx_fec_mac_addr, byte, NULL, 0);
 MODULE_PARM_DESC(mac, "six hex digits, ie. 0x1,0x2,0xc0,0x01,0xba,0xbe");
 
 #define MPC52xx_MESSAGES_DEFAULT ( NETIF_MSG_DRV | NETIF_MSG_PROBE | \
-		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFDOWN )
+		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
 static int debug = -1;	/* the above default */
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "debugging messages level");
