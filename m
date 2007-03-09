Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbXCIVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbXCIVnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933173AbXCIVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:43:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59889 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226AbXCIVnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:43:09 -0500
Message-ID: <45F1D4E8.3030400@garzik.org>
Date: Fri, 09 Mar 2007 16:43:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [git patches] libata (and devres) fixes
References: <20070309163148.GA12848@havoc.gtf.org> <b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com>
In-Reply-To: <b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Comolli wrote:
> Hi.
> This update gives a new warning:
> 
> libata version 2.20 loaded.
> ata_piix 0000:00:1f.1: version 2.10ac1
> ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000118c0 
> irq 14
> ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x000118c8 
> irq 15
> scsi0 : ata_piix
> ata1.00: ATA-6: TOSHIBA MK8025GAS, KA024A, max UDMA/100
> ata1.00: 156301488 sectors, multi 16: LBA
> ata1.01: ATAPI, max MWDMA2
> ata1.00: configured for UDMA/33
> ata1.01: configured for MWDMA2
> scsi1 : ata_piix
> ata2: port disabled. ignoring.
> ata2: reset failed, giving up    <--- THIS IS NEW.
> 
> However, I think it's just bogus as there is ata2 is disabled on this 
> laptop.

That looks like Alan's patch to ata_piix.

	Jeff



