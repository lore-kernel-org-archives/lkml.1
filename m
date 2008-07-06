Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGFRfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGFRfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYGFRem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:34:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:50837 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYGFRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=c1QlS2zQh8LqUScl8bwzOKTkPCYm6xaGjs3Y+YE4DnyOnWRkKhVzLMT1SrAjjssx8u
         zr5mxkoMaVXQ6kLBK2Nf8MGXpOfi6ZSo5Z8ItcI3YTREjejo5qbcRpPOGMomz+CicLcl
         E8CrQdvpAKXx8xW0pvs3LYKlxsmKpHSbxbAK8=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:11 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/50] it8213: fix return value in it8213_init_one()
Content-Disposition: inline; filename=it8213-fix-return-value-in-it8213_init_one.patch
Message-ID: <4871022d.1ade660a.3458.6263@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/it8213.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -184,8 +184,7 @@ static const struct ide_port_info it8213
 
 static int __devinit it8213_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	ide_setup_pci_device(dev, &it8213_chipsets[id->driver_data]);
-	return 0;
+	return ide_setup_pci_device(dev, &it8213_chipsets[id->driver_data]);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {

-- 

