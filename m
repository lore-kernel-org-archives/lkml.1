Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZL1XJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZL1XJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZL1XJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:09:49 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:45380 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751653AbZL1XJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:09:48 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/smc911x.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 18:09:52 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4C9@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/smc911x.c: use %pM to shown MAC address
Thread-Index: AcqIEty85L8N141eReG4LgFBuGi5Jg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 23:09:46.0811 (UTC) FILETIME=[D93098B0:01CA8812]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index 44ebbaa..3c5a4f5 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -2017,10 +2017,8 @@ static int __devinit smc911x_probe(struct net_device *dev)
 					"set using ifconfig\n", dev->name);
 		} else {
 			/* Print the Ethernet address */
-			printk("%s: Ethernet addr: ", dev->name);
-			for (i = 0; i < 5; i++)
-				printk("%2.2x:", dev->dev_addr[i]);
-			printk("%2.2x\n", dev->dev_addr[5]);
+			printk("%s: Ethernet addr: %pM\n",
+				dev->name, dev->dev_addr);
 		}
 
 		if (lp->phy_type == 0) { 
