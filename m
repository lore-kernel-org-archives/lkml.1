Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbYETQyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbYETQyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYETQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:54:39 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64716 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760286AbYETQyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:54:38 -0400
Date: Tue, 20 May 2008 17:53:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Gavin Shan <gshan@alcatel-lucent.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: PIIX4 DMA Timeout
In-Reply-To: <003b01c8ba7a$19f01500$01fca8c0@microsof60b8d6>
Message-ID: <Pine.LNX.4.55.0805201746130.31790@cliff.in.clinika.pl>
References: <003b01c8ba7a$19f01500$01fca8c0@microsof60b8d6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Gavin Shan wrote:

> There has one MV64460 on my board, which includes 2 PCI bridges. PIIX4 is on slot 3 of PCI1.
> But now, IDE driver reported it's timeouted on DMA operation. Thanks in advance for your
> suggestions.
[...]
> PIIX4: chipset revision 1
> PIIX4: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xd8000000-0xd8000007, BIOS settings: hda:pio, hdb:pio
>     ide1: BM-DMA at 0xd8000008-0xd800000f, BIOS settings: hdc:pio, hdd:pio
> hdc: HTE721010G9AT00, ATA DISK drive
> hdc: max request size: 512KiB
> hdc: 195371568 sectors (100030 MB) w/7539KiB Cache, CHS=16383/255/63, UDMA(33)
> hdc: cache flushes supported
>  hdc:<4>hdc: dma_timer_expiry: dma status == 0x26
> hdc: DMA interrupt recovery
> hdc: lost interrupt
> hdc: dma_intr: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: DMA disabled
> ide1: reset: success
>  hdc2 hdc3 hdc4

 It looks like some problem with interrupt routing.  At least with some of
the PIIX chips I recall there was some limitation about how the IDE
interrupts had to be used for DMA to be operational.  For PIO modes there
were no restrictions.  Do you have chip-level documentation for your
board?

  Maciej
