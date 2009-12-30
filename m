Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZL3Szk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZL3Szk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZL3Szi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:55:38 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:38331 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752752AbZL3Szg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:55:36 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/atm/nicstar.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 13:55:36 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F648@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/atm/nicstar.c: use %pM to show MAC address
Thread-Index: AcqJgawvQaAiX6G+RQ6HUK66hrD/yg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 18:55:35.0366 (UTC) FILETIME=[AB724660:01CA8981]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 3da804b..5083840 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -807,9 +807,7 @@ static int __devinit ns_init_card(int i, struct pci_dev *pcidev)
       }
    }
 
-   printk("nicstar%d: MAC address %02X:%02X:%02X:%02X:%02X:%02X\n", i,
-          card->atmdev->esi[0], card->atmdev->esi[1], card->atmdev->esi[2],
-          card->atmdev->esi[3], card->atmdev->esi[4], card->atmdev->esi[5]);
+   printk("nicstar%d: MAC address %pM\n", i, card->atmdev->esi);
 
    card->atmdev->dev_data = card;
    card->atmdev->ci_range.vpi_bits = card->vpibits; 
