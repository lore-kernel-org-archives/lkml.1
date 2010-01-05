Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001Ab0AEQkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0AEQkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615Ab0AEQkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:40:35 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6958 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754561Ab0AEQkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:40:35 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 11:40:34 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/atm/idt77252.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:24:23 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050924.23939.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

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
