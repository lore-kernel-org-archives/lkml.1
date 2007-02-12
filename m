Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXBLUmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXBLUmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965279AbXBLUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:42:45 -0500
Received: from guri.is.scarlet.be ([193.74.71.22]:35429 "EHLO
	guri.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268AbXBLUmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:42:44 -0500
Message-ID: <45D0D133.8070801@scarlet.be>
Date: Mon, 12 Feb 2007 20:42:27 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Luming Yu <luming.yu@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com>
In-Reply-To: <45CFBBD1.5090703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Tejun Heo wrote:
> Please test the attached patch over 2.6.20.
> 
> Thanks.
> 
It's already too late so quick and dirty rebuild of 2.6.20-git6 (failled before your patch) but now your patch fixe the pb:
[snip]
ata_piix 0000:00:07.1: version 2.00ac7
ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
scsi3 : ata_piix
ata1.00: ATA-4: QUANTUM FIREBALLlct10 15, A03.0900, max UDMA/66
ata1.00: 29336832 sectors, multi 16: LBA
ata1.00: configured for UDMA/33
scsi4 : ata_piix
ata2.01: ATAPI, max MWDMA1
ata2.01: configured for MWDMA1
scsi 3:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A03. PQ: 0 ANSI: 5
SCSI device sdc: 29336832 512-byte hdwr sectors (15020 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 29336832 512-byte hdwr sectors (15020 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 sdc11 sdc12 sdc13 sdc14 sdc15 >
sd 3:0:0:0: Attached scsi disk sdc
sd 3:0:0:0: Attached scsi generic sg2 type 0
scsi 4:0:1:0: CD-ROM            PHILIPS  CDD3610 CD-R/RW  3.09 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 6x/6x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:1:0: Attached scsi CD-ROM sr0
sr 4:0:1:0: Attached scsi generic sg3 type 5
[snip]

cool ;-)

Sorry, I will try later against 2.6.20 (i guess it will also fixe the pb) and attempt to burn a cd.
I will advise you asap.

Thanks again,
	Joel
