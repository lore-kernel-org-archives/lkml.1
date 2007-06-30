Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXF3Oov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXF3Oov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXF3Oom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:44:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:10821 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXF3Ool (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SWaQVEL3+EZVQqn8U5zDyQZC5hRggFZWKgJ1+pjdleSlWqbpb+hdK6r3jHtE+5+UM39h6VIO6PB79xliQpfj72pnO8KBXnS1KWA6Tq9okfxUj2joVhqClcx6TxPbvlohDqdvRYR49MNNULvc3VSnsz5Y0DYXZnRB3ob9E4DfaOo=
Date: Sat, 30 Jun 2007 16:44:36 +0200
From: Florian Attenberger <valdyn@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2.6.22-rc6] add PCI-ID for Adaptec 1430SA 4-Port SATA
	Controller
Message-ID: <20070630144436.GA13479@master.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

added this pci id to support my:
lspci:
01:00.0 RAID bus controller: Adaptec Unknown device 0243 (rev 02)
lspci -n:
01:00.0 0104: 9005:0243 (rev 02)

seems to work fine.

florian attenberger


--- 2.6.22-rc6/drivers/ata/sata_mv.c	2007-06-30 16:21:47.462020256 +0200
+++ 2.6.22-rc6.mine/drivers/ata/sata_mv.c	2007-06-30 16:25:25.999165444 +0200
@@ -582,6 +582,9 @@ static const struct pci_device_id mv_pci
 
 	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
 
+	/* Adaptec 1430SA */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
+
 	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
 
 	/* add Marvell 7042 support */
