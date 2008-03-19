Return-Path: <linux-kernel-owner+w=401wt.eu-S935108AbYCSXQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935108AbYCSXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933294AbYCSVmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:42:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:51623 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbYCSVmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:42:03 -0400
Message-ID: <47E0D5C8.9070005@gmail.com>
Date: Wed, 19 Mar 2008 17:58:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <47E087DF.7070101@gmail.com> <47E0883A.9010507@gmail.com> <200803190853.10030.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803190853.10030.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Armin Hemmann wrote:
> 
> [   37.123980] ahci 0000:00:0a.0: version 3.0
> [   37.124155] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> [   37.124199] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
> (level, low) -> IRQ 23
> [   37.124533] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
> [   38.124731] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
> impl IDE mode
> [   38.124780] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
> [   38.124819] PCI: Setting latency timer of device 0000:00:0a.0 to 64
> [   38.125020] scsi0 : ahci
> [   38.125116] scsi1 : ahci
> [   38.125182] scsi2 : ahci
> [   38.125248] scsi3 : ahci
> [   38.125337] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
> irq 315
> [   38.125384] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
> irq 315
> [   38.125432] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
> irq 315
> [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
> irq 315
> [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
> [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
> [   38.598405] ata1.00: configured for UDMA/133
> [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
> [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [   39.086268] ata2.00: configured for UDMA/133

So, just to confirm.  With the updated patch, you don't see any problem,
right?

-- 
tejun
