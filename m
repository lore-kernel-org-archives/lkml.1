Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYGCMZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYGCMZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYGCMZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:25:07 -0400
Received: from lucidpixels.com ([75.144.35.66]:33895 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbYGCMZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:25:05 -0400
Date: Thu, 3 Jul 2008 04:51:04 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Message-ID: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the motherboard itself (all drives configured for AHCI)

[    2.360648] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.678244] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    2.678594] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.684566] ata1.00: configured for UDMA/133

On the PCI-e cards:

[   16.136568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   16.155682] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   16.156545] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   16.162949] ata11.00: configured for UDMA/100

How come the PCI-e card configured the drive for UDMA/100 and not UDMA/133?

Perhaps the PCI-e card/driver does not configure/have AHCI functionality, 
or?

The mobo: Intel DG965WH
The card: 03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial 
ATA Raid II Controller (rev 01)

The hard drives are the same make/model.

Thanks,

Justin.

