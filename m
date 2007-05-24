Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbXEXXdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbXEXXdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXEXXdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:33:23 -0400
Received: from yurusanai.de ([85.25.62.54]:42999 "EHLO yurusanai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbXEXXdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:33:22 -0400
Message-ID: <43030.80.228.59.88.1180049606.squirrel@yurusanai.de>
In-Reply-To: <200705250015.02222.bzolnier@gmail.com>
References: <48969.80.228.60.226.1180041664.squirrel@yurusanai.de>
    <200705250015.02222.bzolnier@gmail.com>
Date: Fri, 25 May 2007 01:33:26 +0200 (CEST)
Subject: Re: HPT366 not enabled by kernel 2.6.21.2
From: "Pascal Schmidt" <pasukaru@yurusanai.de>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello again!

> The fix from Sergei (queued for 2.6.21.3) is here:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=queue-2.6.21/hpt366-don-t-check-enablebits-for-hpt36x.patch;h=0833e0a37e23ed103a18ca93684201e1cb94a0a9
>
> [ it has already been merged into 2.6.22 tree ]

Thank you. The patch works for me.

HPT366: IDE controller at PCI slot 0000:02:0a.0
ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
HPT366: chipset revision 1
HPT366: using 33 MHz PCI clock
HPT366: 100% native mode on irq 18
    ide2: BM-DMA at 0xd300-0xd307, BIOS settings: hde:pio, hdf:pio
ACPI: PCI Interrupt 0000:02:0a.1[A] -> GSI 18 (level, low) -> IRQ 18
HPT366: using 33 MHz PCI clock
    ide3: BM-DMA at 0xd600-0xd607, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: TOSHIBA THNCF1G02MG, CFA DISK drive
ide2 at 0xd100-0xd107,0xd202 on irq 18

-- 
Ciao,
Pascal

