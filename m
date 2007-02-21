Return-Path: <linux-kernel-owner+w=401wt.eu-S1422732AbXBUR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422732AbXBUR4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422738AbXBUR4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:56:18 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:49384 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422732AbXBUR4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:56:17 -0500
Date: Wed, 21 Feb 2007 18:56:33 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [git patches] libata ACPI support
Message-ID: <20070221175633.GE5143@mail.muni.cz>
References: <20070220214716.GA3690@mail.muni.cz> <45DB74D9.206@garzik.org> <20070220232633.GA3598@mail.muni.cz> <45DB88FD.5020509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45DB88FD.5020509@garzik.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (tirith.ics.muni.cz [147.251.4.35]); Wed, 21 Feb 2007 18:56:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 06:49:17PM -0500, Jeff Garzik wrote:
> Can you narrow down the -gitX release further?  i.e. does 2.6.20-git13 
> perform at full speed?  -git13 includes several libata changes, but does 
> not include the ACPI additions.
> 
> Since this is an ACPI execution error in the bug, that would tend to 
> point to bad BIOS tables.  But since there is a performance drop that 
> does not disappear with acpi=off, there might also be another factor, 
> unrelated to ACPI, at play here.

I've noticed on lkm another bug report which has pointed me to this:
ata_piix 0000:00:1f.1: version 2.00ac7
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
scsi0 : ata_piix
ata1.00: ATA-6: ST9100824A, 3.04, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48
ata1.01: ATAPI, max UDMA/33
ata1.00: configured for UDMA/33
ata1.01: configured for UDMA/33

Both ports are for some reason configured as UDMA/33.

-- 
Luká¹ Hejtmánek
