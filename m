Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZAFSfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZAFSfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZAFSeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:34:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:48965 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZAFSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Bbzwp1QnNbppWVTMPfKNU1pdUmMiiEqjTcAtzT+FwPvCcS0tyFwRFlP0XlKCKgmmdG
         l3hHNw3dVYnN/HeWIUq555zXw0K3WukxeXPjAX/r02y1ezj6R5d4iRUHkaLFrychImQR
         2G/hdFI2L2xbr4G8hntm7Y7TDvn2yVDSh545E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:35:26 +0100
Message-Id: <20090106183526.21193.24866.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] sl82c105: remove dead code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sl82c105: remove dead code

CONFIG_LOPEC and CONFIG_SANDPOINT config options are gone.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/sl82c105.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -310,10 +310,6 @@ static const struct ide_port_info sl82c1
 	.dma_ops	= &sl82c105_dma_ops,
 	.host_flags	= IDE_HFLAG_IO_32BIT |
 			  IDE_HFLAG_UNMASK_IRQS |
-/* FIXME: check for Compatibility mode in generic IDE PCI code */
-#if defined(CONFIG_LOPEC) || defined(CONFIG_SANDPOINT)
-			  IDE_HFLAG_FORCE_LEGACY_IRQS |
-#endif
 			  IDE_HFLAG_SERIALIZE_DMA |
 			  IDE_HFLAG_NO_AUTODMA,
 	.pio_mask	= ATA_PIO5,
