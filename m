Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZL3Tlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZL3Tlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZL3Tll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:41:41 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:41755 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752948AbZL3Tll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:41:41 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/atm/idt77252.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:41:41 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F664@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/atm/idt77252.c: use %pM to show MAC address
Thread-Index: AcqJiBwVAa+UlfnhQM+GHIAxf5cgMQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 19:41:39.0625 (UTC) FILETIME=[1B12B990:01CA8988]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index e33ae00..01f36c0 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3557,10 +3557,7 @@ init_card(struct atm_dev *dev)
 	if (tmp) {
 		memcpy(card->atmdev->esi, tmp->dev_addr, 6);
 
-		printk("%s: ESI %02x:%02x:%02x:%02x:%02x:%02x\n",
-		       card->name, card->atmdev->esi[0], card->atmdev->esi[1],
-		       card->atmdev->esi[2], card->atmdev->esi[3],
-		       card->atmdev->esi[4], card->atmdev->esi[5]);
+		printk("%s: ESI %pM\n", card->name, card->atmdev->esi);
 	}
 	/*
 	 * XXX: </hack> 
