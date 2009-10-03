Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZJCDj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZJCDj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 23:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZJCDj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 23:39:57 -0400
Received: from ara.aytolacoruna.es ([91.117.124.165]:37384 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbZJCDj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 23:39:56 -0400
Date: Sat, 3 Oct 2009 05:39:42 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
Message-ID: <20091003033942.GA8129@dis.manty.net>
References: <20090930110529.GA3676@dis.manty.net>
 <20091001.114755.132624639.davem@davemloft.net>
 <20091001.115310.100974682.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001.115310.100974682.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, there's a small bug in the test patch, please use this one
> instead.

Applied it to 2.6.31.1, I'll wait and see what the weekend tells us.

BTW, I forgot to include info on the controller, disks, ... on the report,
so here they go just in case they make any difference.

Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:07.1: VIA vt82c596b (rev 23) IDE UDMA66
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x10)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xe800-0xe807
    ide1: BM-DMA at 0xe808-0xe80f
Probing IDE interface ide0...
hda: HL-DT-STDVD-RAM GH22NP20, ATAPI CD/DVD-ROM drive
hdb: ST3160021A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
Probing IDE interface ide1...
hdc: ST3160021A, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
hdb: max request size: 512KiB
hdb: Host Protected Area detected.
        current capacity is 312579695 sectors (160040 MB)
        native  capacity is 312581808 sectors (160041 MB)
hdb: 312579695 sectors (160040 MB) w/2048KiB Cache, CHS=19457/255/63
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3
hdc: max request size: 512KiB
hdc: Host Protected Area detected.
        current capacity is 312579695 sectors (160040 MB)
        native  capacity is 312581808 sectors (160041 MB)
hdc: 312579695 sectors (160040 MB) w/2048KiB Cache, CHS=19457/255/63
hdc: cache flushes supported
 hdc: hdc1 hdc2 hdc3
ide-cd driver 5.00
ide-cd: hda: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20

Regards...
-- 
Manty/BestiaTester -> http://manty.net
