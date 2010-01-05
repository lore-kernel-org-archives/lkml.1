Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071Ab0AEQkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0AEQkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032Ab0AEQki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:40:38 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6958 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754982Ab0AEQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:40:37 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 11:40:34 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/atm/nicstar.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:28:08 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050928.09040.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

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
