Return-Path: <linux-kernel-owner+w=401wt.eu-S1946760AbXD3UVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946760AbXD3UVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946764AbXD3UVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:21:13 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:61178 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946760AbXD3UVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:21:10 -0400
Date: Mon, 30 Apr 2007 16:21:07 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 libata cdrom
Message-ID: <20070430202107.GF5942@electro-mechanical.com>
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4635C35D.1020807@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:22:21PM +0200, Tejun Heo wrote:
> William Thompson wrote:
> > I've been playing with libata on a few machines and I found that this machine
> > (An old Dell Dimension L866r) gives me this when it loads and does not give me
> > access to the cdrom.  This is the only machine that I've tested that I know
> > for a fact cannot do DMA on the cdrom.  I searched and noticed a similar
> > problem with 2.6.19-rc versions but I'm not sure if it's the same problem.
> > 
> > dmesg output:
> > libata version 2.00 loaded.
> > ata_piix 0000:00:1f.1: version 2.00ac7
> > PCI: Setting latency timer of device 0000:00:1f.1 to 64
> > ata1: PATA max UDMA/66 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
> > ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
> > scsi0 : ata_piix
> > ata1.00: ATA-4, max UDMA/33, 10018890 sectors: LBA
> > ata1.00: ata1: dev 0 multi count 16
> > ata1.00: configured for UDMA/33
> > scsi1 : ata_piix
> > ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> 
> Hmm... IDENTIFY failed on the second port.  How reproducible is the
> problem?  Every time?  Does it work with the IDE driver?  If so, please
> post the result of 'hdparm -I /dev/hdX'.

Reproducible?  Everytime

Yes, it works fine with the IDE driver, so long as DMA is disabled.

hdparm -I:
/dev/hdc:

ATAPI CD-ROM, with removable media
        Model Number:           Lite-On LTN483S 48x Max
        Serial Number:
        Firmware Revision:      PD02
Standards:
        Used: ATAPI for CD-ROMs, SFF-8020i, r2.5
        Supported: CD-ROM ATAPI-1
Configuration:
        DRQ response: <=10ms with INTRQ
        Packet size: 12 bytes
Capabilities:
        LBA, IORDY(can be disabled)
        DMA: sdma0 sdma1 sdma2 mdma0 mdma1 mdma2 udma0 udma1 *udma2
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=120ns  IORDY flow control=120ns
