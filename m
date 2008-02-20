Return-Path: <linux-kernel-owner+w=401wt.eu-S1764843AbYBTW1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764843AbYBTW1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYBTW12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:27:28 -0500
Received: from ns.suse.de ([195.135.220.2]:33414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYBTW11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:27:27 -0500
Subject: patch pci-remove-parisc-consumer-of-the-pci-global_list.patch added to gregkh-2.6 tree
To: James.Bottomley@HansenPartnership.com, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 20 Feb 2008 14:25:02 -0800
In-Reply-To: <1203542065.3109.42.camel@localhost.localdomain>
Message-ID: <12035463024141@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: remove parisc consumer of the pci global_list

to my gregkh-2.6 tree.  Its filename is

     pci-remove-parisc-consumer-of-the-pci-global_list.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From James.Bottomley@HansenPartnership.com  Wed Feb 20 14:22:51 2008
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 20 Feb 2008 15:14:24 -0600
Subject: PCI: remove parisc consumer of the pci global_list
To: Greg KH <greg@kroah.com>
Cc: Parisc List <linux-parisc@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1203542065.3109.42.camel@localhost.localdomain>

Remove the parisc usage of the global_list, as it's not needed anymore.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parisc/dino.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -496,7 +496,6 @@ dino_card_setup(struct pci_bus *bus, voi
 		list_for_each_safe(ln, tmp_ln, &bus->devices) {
 			struct pci_dev *dev = pci_dev_b(ln);
 
-			list_del(&dev->global_list);
 			list_del(&dev->bus_list);
 		}
 			


Patches currently in gregkh-2.6 which might be from James.Bottomley@HansenPartnership.com are

pci/pci-remove-parisc-consumer-of-the-pci-global_list.patch
