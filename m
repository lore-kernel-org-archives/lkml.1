Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZCSNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZCSNNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZCSNNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:13:10 -0400
Received: from postkast.cyber.ee ([195.50.202.7]:36016 "EHLO postkast.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZCSNNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:13:09 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 09:13:08 EDT
Date: Thu, 19 Mar 2009 15:04:33 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Lava dual parallel PCI card IRQ problem
In-Reply-To: <20090318143921.22B5B13A4B0@koiott.tartu-labor>
Message-ID: <Pine.LNX.4.64.0903191500520.4721@ondatra.tartu-labor>
References: <20090318143921.22B5B13A4B0@koiott.tartu-labor>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First cut to try
>
> parport: Use the PCI IRQ if offered
>
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Doesn't seem to do anything here on a 1-port Lava PCI parallel card

parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
parport_pc 0000:01:0b.0: PCI INT A -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
PCI parallel port detected: 1407:8000, I/O at 0xdff0(0x0), IRQ 11
parport1: PC-style at 0xdff0 [PCSPP,TRISTATE,EPP]
[...]
lp0: using parport0 (interrupt-driven).
lp1: using parport1 (polling).

lspci tells this:
01:0b.0 Parallel controller [0701]: Lava Computer mfg Inc Lava Parallel [1407:8000] (prog-if 01 [BiDir])
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at dff0 [size=8]
         Kernel driver in use: parport_pc


-- 
Meelis Roos (mroos@linux.ee)
