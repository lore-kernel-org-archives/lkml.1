Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXCZUTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXCZUTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXCZUTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:19:09 -0400
Received: from smtp.ono.com ([62.42.230.12]:15339 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752691AbXCZUTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:19:06 -0400
Date: Mon, 26 Mar 2007 22:18:44 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Wrong IDE cable detection in libata [Re: 2.6.21-rc4-mm1]
Message-ID: <20070326221844.38bf8840@werewolf-wl>
In-Reply-To: <4607A820.60103@gmail.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070326022420.224cc4f2@werewolf-wl>
	<4607A820.60103@gmail.com>
X-Mailer: Claws Mail 2.8.1cvs51 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 20:01:52 +0900, Tejun Heo <htejun@gmail.com> wrote:

> J.A. Magallón wrote:
> > Libata seems to misdetect my cable.
> > I have double-checked and the cable is 80 pin...
> 
> Does the following patch fix your problem?
> 
>   http://article.gmane.org/gmane.linux.ide/17444
> 
> (You can get the raw message by appending /raw to the URL).
> 

Yes it works !!

Disk is back at nice speed of 50 Mb/s.

dmesg:

ata_piix 0000:00:1f.1: version 2.10ac1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
scsi0 : ata_piix
ata1.00: ATAPI, max UDMA/33
ata1.01: ATAPI, max MWDMA0, CDB intr
ata1.00: configured for UDMA/33
ata1.01: configured for PIO3
scsi1 : ata_piix
ata2.00: ATA-6: ST3120022A, 3.06, max UDMA/100
ata2.00: 234441648 sectors, multi 16: LBA48 
ata2.01: ATAPI, max UDMA/33
ata2.00: configured for UDMA/100    <=============
ata2.01: configured for UDMA/33     <=============

Thanks !!

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
