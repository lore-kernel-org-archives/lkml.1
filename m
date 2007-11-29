Return-Path: <linux-kernel-owner+w=401wt.eu-S933342AbXK2Thv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbXK2Thv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXK2Thj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:37:39 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:49949 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXK2Thi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:37:38 -0500
Date: Thu, 29 Nov 2007 19:37:28 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Peculiar out-of-sync boot log lines
Message-ID: <20071129193728.2f1c237e@linuxamd.linicks.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

2.6.23.9

I have noticed after applying Bart's patch to word93 blacklist my new
DVD drive:

http://lkml.org/lkml/2007/10/23/475

I see now in logs (look at the hdd line:

[dmesg]
hdc: 39876480 sectors (20416 MB) w/2048KiB Cache, CHS=39560/16/63,
UDMA(66)
hdc: cache flushes not supported
 hdc: hdc1
hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
skipping word 93 validity check
, UDMA(66)
Uniform CD-ROM driver Revision: 3.20


<7> ??  And the ", UDMA(66)" gets new lined, so in syslog it appears all
by itself:


[/var/log/syslog]
Nov 29 19:22:00 linuxamd kernel: hda: Maxtor 6Y080L0, ATA DISK drive
Nov 29 19:22:00 linuxamd kernel: hdb: Maxtor 51536H2, ATA DISK drive
Nov 29 19:22:00 linuxamd kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Nov 29 19:22:00 linuxamd kernel: hdc: Maxtor 52049H3, ATA DISK drive
Nov 29 19:22:00 linuxamd kernel: hdd: TSSTcorp CDDVDW SH-S202J, ATAPI
CD/DVD-ROM drive
Nov 29 19:22:00 linuxamd kernel: ide1 at 0x170-0x177,0x376 on irq 15
Nov 29 19:22:00 linuxamd kernel: , UDMA(66)



I have tried to trace this, but cannot see anywhere printk
does this.

Nick
-- 
Free Software Foundation Associate Member 5508
