Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbYFFVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbYFFVlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbYFFVkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:40:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:8741 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760798AbYFFVkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=PqEPSjaiauM0RvbK1tvlJ/PPdkTejPlZkTuSy2o+KzofYCj9v5Av296dV/OKx88YoE
         G8nSr6XiqWTXsEUiNd6ATeqo+05NN5D4NX1w1teqI+bsHjEej0lb+s5YpIDtf0JQjQls
         /RQpR47GgAAvdthGQxhdLl313Iz0RSWqlznDs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] sgiioc4: use driver name for resource allocation
Date: Fri, 6 Jun 2008 23:34:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806062334.23364.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jeremy Higdon <jeremy@sgi.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sgiioc4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -608,11 +608,11 @@ sgiioc4_ide_setup_pci_device(struct pci_
 
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
 	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
-	    hwif->name)) {
+	    DRV_NAME)) {
 		printk(KERN_ERR
 			"%s : %s -- ERROR, Addresses "
 			"0x%p to 0x%p ALREADY in use\n",
-		       __func__, hwif->name, (void *) cmd_phys_base,
+		       __func__, DRV_NAME, (void *) cmd_phys_base,
 		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		return -ENOMEM;
 	}
