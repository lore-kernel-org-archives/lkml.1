Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZL1XaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZL1XaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZL1XaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:30:06 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:43701 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751088AbZL1XaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:30:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/via-velocity.c: use %pM to shown MAC address
Date: Mon, 28 Dec 2009 18:30:08 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F4CD@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/via-velocity.c: use %pM to shown MAC address
Thread-Index: AcqIFbFf65UgOMLAQTSKH9EWB9gj7g==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 28 Dec 2009 23:30:02.0545 (UTC) FILETIME=[ADD2E210:01CA8815]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 4ceb441..cee8fa2 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -2702,10 +2702,8 @@ static void __devinit velocity_print_info(struct velocity_info *vptr)
 	struct net_device *dev = vptr->dev;
 
 	printk(KERN_INFO "%s: %s\n", dev->name, get_chip_name(vptr->chip_id));
-	printk(KERN_INFO "%s: Ethernet Address: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
-		dev->name,
-		dev->dev_addr[0], dev->dev_addr[1], dev->dev_addr[2],
-		dev->dev_addr[3], dev->dev_addr[4], dev->dev_addr[5]);
+	printk(KERN_INFO "%s: Ethernet Address: %pM\n",
+		dev->name, dev->dev_addr);
 }
 
 static u32 velocity_get_link(struct net_device *dev) 
