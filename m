Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZL3UUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZL3UUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZL3UUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:20:46 -0500
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:51234 "HELO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752959AbZL3UUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:20:46 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/stmmac/gmac.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:20:46 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F674@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/stmmac/gmac.c: use %pM to show MAC address
Thread-Index: AcqJjZHkRj2hPFOHQm+ZnChM5QPL1w==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:20:44.0237 (UTC) FILETIME=[90921FD0:01CA898D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>
---

diff --git a/drivers/net/stmmac/gmac.c b/drivers/net/stmmac/gmac.c
index 52586ee..7700772 100644
--- a/drivers/net/stmmac/gmac.c
+++ b/drivers/net/stmmac/gmac.c
@@ -481,12 +481,8 @@ static void gmac_set_filter(struct net_device *dev)
 				gmac_set_umac_addr(ioaddr, uc_ptr->da_addr,
 						i + 1);
 
-				DBG(KERN_INFO "\t%d "
-				"- Unicast addr %02x:%02x:%02x:%02x:%02x:"
-				"%02x\n", i + 1,
-				uc_ptr->da_addr[0], uc_ptr->da_addr[1],
-				uc_ptr->da_addr[2], uc_ptr->da_addr[3],
-				uc_ptr->da_addr[4], uc_ptr->da_addr[5]);
+				DBG(KERN_INFO "\t%d - Unicast addr %pM\n",
+					i + 1, uc_ptr->da_addr);
 				uc_ptr = uc_ptr->next;
 		}
 	} 
