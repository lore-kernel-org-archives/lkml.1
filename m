Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbXD0SMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbXD0SMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXD0SMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:12:15 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:61716 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756099AbXD0SMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:12:14 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 14:12:14 EDT
Date: Fri, 27 Apr 2007 13:52:05 -0400
From: William Thompson <wt@electro-mechanical.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 libata cdrom
Message-ID: <20070427175205.GD7809@electro-mechanical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been playing with libata on a few machines and I found that this machine
(An old Dell Dimension L866r) gives me this when it loads and does not give me
access to the cdrom.  This is the only machine that I've tested that I know
for a fact cannot do DMA on the cdrom.  I searched and noticed a similar
problem with 2.6.19-rc versions but I'm not sure if it's the same problem.

dmesg output:
libata version 2.00 loaded.
ata_piix 0000:00:1f.1: version 2.00ac7
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/66 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
scsi0 : ata_piix
ata1.00: ATA-4, max UDMA/33, 10018890 sectors: LBA
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/33
scsi1 : ata_piix
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
scsi 0:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A08. PQ: 0 ANSI: 5

lspci on the ide controller:
0000:00:1f.1 0101: 8086:2411 (rev 02) (prog-if 80 [Master])
        Subsystem: 8086:2411
        Flags: bus master, medium devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        I/O ports at ffa0 [size=16]

The cdrom is a Lite-On LTN483S
