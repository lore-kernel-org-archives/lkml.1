Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbXGJUwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbXGJUwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXGJUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:51:59 -0400
Received: from mbox1.netikka.net ([213.250.81.202]:34517 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXGJUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:51:58 -0400
Message-ID: <4693F16A.4050709@mandriva.org>
Date: Tue, 10 Jul 2007 23:51:54 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Problem with SiS Ide/Pata/Sata on 2.6.22-rc7-git4
References: <4692A7C3.9030802@mandriva.org> <20070709232742.004def28@the-village.bc.nu>
In-Reply-To: <20070709232742.004def28@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox skrev:
>> If you modprobe only sis5513
>>   OR
>> If you modprobe only sis5513 and then sata_sis/pata_sis:
>>   - you get this:
>>     (the hdb drive does not get detected/usable)
> 
> Don't mix old and new IDE like that. We allow both so you can use old SIS
> and new Jmicron etc for example but there are some cases where trying to
> load both old and new IDE support for the same chip will do strange
> things.
> 

But there is still a regression here compared to 2.6.17...

If you load only sis5513 on a 2.6.22 you still get:
--- quote ---
<6>SIS5513: chipset revision 1
<6>SIS5513: not 100% native mode: will probe irqs later
<6>SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
<6>    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:pio, hdb:pio
<6>    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:pio
<7>Probing IDE interface ide0...
<4>hdb: QUANTUM FIREBALLlct15 07, ATA DISK drive
<4>hdb: host side 80-wire cable detection failed, limiting max speed to 
UDMA33
<7>hdb: selected mode 0x42
--- quote ---

wich does not happend on 2.6.17...

The disk in question is ATA66 capable

--
Thomas
