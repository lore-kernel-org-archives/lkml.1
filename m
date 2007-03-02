Return-Path: <linux-kernel-owner+w=401wt.eu-S2992705AbXCBWwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992705AbXCBWwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992706AbXCBWwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:52:50 -0500
Received: from smtp24.orange.fr ([193.252.22.25]:23838 "EHLO smtp24.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992705AbXCBWwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:52:49 -0500
X-ME-UUID: 20070302225247537.833F21C000A1@mwinf2433.orange.fr
Message-ID: <45E8AAC0.5060702@free.fr>
Date: Fri, 02 Mar 2007 23:52:48 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.0.9) Gecko/20061222 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1: pata_via: wrong cable detection
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02.03.2007 12:00, Andrew Morton a écrit :
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/

Hello,

My 2 hard drives are connected to the same pata slot with a 80-wire cable.

But kernel found a 40-wire cable for the master HD!


$ dmesg | grep ata 
...
pata_via 0000:00:04.1: version 0.2.1
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001b800 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001b808 irq 15
scsi0 : pata_via
ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
ata1.00: 78165360 sectors, multi 16: LBA 
ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
ata1.01: 160086528 sectors, multi 16: LBA 
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
ata1.01: configured for UDMA/100
scsi1 : pata_via
ata2.00: ATAPI, max UDMA/33
ata2.01: ATAPI, max MWDMA2, CDB intr
ata2.00: configured for UDMA/33
ata2.01: configured for MWDMA2
...

(A DVD burner and a CDROM drive are plugged on the 2nd pata slot 
with a 40-wire cable).

~~
laurent


