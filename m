Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZLBR5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZLBR5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZLBR5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:57:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:48316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZLBR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=TfYSW4h1GyoXackqxrFElsHduHWUoPxcap3RGC0XclIfmdFUJ2OfvyomnMXDXJnZ6d
         bK/fPjNLU5TRwGTSCGQO8v7amrbqMq5VR6vxDh+lGPVL/KLp5cc28KQElwxVjmcFHQRc
         AAVNLKSDhQztFK5e7+jZBBo3bOI3mtsUliRDY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] cs5535: add pci id for AMD based CS5535 controllers
Date: Wed, 2 Dec 2009 18:56:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912021856.34029.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on commit 02cb009 for pata_cs5530.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cs5535.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -187,6 +187,7 @@ static int __devinit cs5535_init_one(str
 
 static const struct pci_device_id cs5535_pci_tbl[] = {
 	{ PCI_VDEVICE(NS, PCI_DEVICE_ID_NS_CS5535_IDE), 0 },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CS5535_IDE), },
 	{ 0, },
 };
 
