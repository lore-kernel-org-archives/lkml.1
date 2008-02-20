Return-Path: <linux-kernel-owner+w=401wt.eu-S1764785AbYBTVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764785AbYBTVP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760874AbYBTVOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:14:46 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49475 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759420AbYBTVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:14:32 -0500
Subject: [PATCH] pci: remove parisc consumer of the pci global_list
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <greg@kroah.com>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 15:14:24 -0600
Message-Id: <1203542065.3109.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch  pci-remove-global-list-of-pci-devices.patch misses the parisc
dino use of this.  However, it's a simple removal job.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 03c763c..d9c6322 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -496,7 +496,6 @@ dino_card_setup(struct pci_bus *bus, void __iomem *base_addr)
 		list_for_each_safe(ln, tmp_ln, &bus->devices) {
 			struct pci_dev *dev = pci_dev_b(ln);
 
-			list_del(&dev->global_list);
 			list_del(&dev->bus_list);
 		}
 			


