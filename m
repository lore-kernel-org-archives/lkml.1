Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbXFJQDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbXFJQDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbXFJQCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:02:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57405 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbXFJQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:02:53 -0400
Date: Sun, 10 Jun 2007 17:08:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: libata limiting to UDMA/33 instead of UDMA/100
Message-ID: <20070610170810.71677857@the-village.bc.nu>
In-Reply-To: <20070609132124.247a6646@laptop.hypervisor.org>
References: <20070609132124.247a6646@laptop.hypervisor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 13:21:24 +0200
"Udo A. Steinberg" <us15@os.inf.tu-dresden.de> wrote:

> Hi,
> 
> After switching an older machine over from the PDC20265 PATA driver to the
> libata driver pata_pdc202xx_old my HDDs are now limited to UDMA/33. With the
> old driver they were happily running with UDMA/100.

...

> 
> I'm including the relevant kernel output for both cases below.

Thanks.

> scsi0 : pata_pdc202xx_old
> scsi1 : pata_pdc202xx_old
> ata1: PATA max UDMA/100 cmd 0x00019400 ctl 0x00019002 bmdma 0x00018000 irq 0
> ata2: PATA max UDMA/100 cmd 0x00018800 ctl 0x00018402 bmdma 0x00018008 irq 0
> ata1.00: ata_hpa_resize 1: sectors = 60036480, hpa_sectors = 60036480
> ata1.00: ATA-5: IBM-DTLA-307030, TX4OA5AA, max UDMA/100
> ata1.00: 60036480 sectors, multi 16: LBA 
> ata1.01: ata_hpa_resize 1: sectors = 241254720, hpa_sectors = 241254720
> ata1.01: ATA-6: IC35L120AVV207-0, V24OA63A, max UDMA/100
> ata1.01: 241254720 sectors, multi 16: LBA48 
> ata1.00: limited to UDMA/33 due to 40-wire cable
> ata1.01: limited to UDMA/33 due to 40-wire cable

What sort of cable is actually in use here ?

Alan
