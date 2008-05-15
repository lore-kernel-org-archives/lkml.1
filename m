Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYEOLPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYEOLPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYEOLPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:15:34 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:34071 "EHLO
	toronto.xi-lite.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752993AbYEOLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:15:33 -0400
Message-ID: <482C1B51.7050906@parrot.com>
Date: Thu, 15 May 2008 13:15:29 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_piix 2.6.25 sata failure
References: <482949CB.7000208@parrot.com> <482BE929.7090009@parrot.com> <482BECF5.2070801@gmail.com>
In-Reply-To: <482BECF5.2070801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2008 11:16:11.0324 (UTC) FILETIME=[149FBFC0:01C8B67D]
X-AV-Checked: No Virus Found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tejun Heo wrote:
> Matthieu CASTET wrote:
>> Hi Tejun,
>>
>> Matthieu CASTET wrote:
>>
>>
>> Any idea how to debug this.
>>
>> For information this happen on a HP Compaq dc7700p, and there no way 
>> on the bios to change the controller to ahci mode
> 
> Yeah, I wrote a patch for that yesterday and forgot to actually send it. 
>  Can you please test the attached patch?
> 

thanks, it seems to work :

  ata_piix 0000:00:1f.2: version 2.12
  ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 18 (level, low) -> IRQ 18
  ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
  PCI: Setting latency timer of device 0000:00:1f.2 to 64
  scsi0 : ata_piix
  scsi1 : ata_piix
  ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x11f0 irq 14
  ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x11f8 irq 15
  ata1: link in powersave mode (ipm=2), forcing hardreset
  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata1.00: ATA-7: SAMSUNG HD080HJ/P, ZH100-43, max UDMA/100
  ata1.00: 156301488 sectors, multi 16: LBA48
  ata1.00: configured for UDMA/100
  ata2: link in powersave mode (ipm=2), forcing hardreset
  ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata2.00: ATA-7: SAMSUNG HD160JJ/P, ZM100-46, max UDMA7
  ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
  ata2.01: ATAPI: HL-DT-STDVD+-RW GSA-H31L, 1.05, max UDMA/100
  ata2.00: configured for UDMA/133
  ata2.01: configured for UDMA/100


Matthieu
