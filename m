Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbXJXKca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbXJXKca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXJXKcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:32:23 -0400
Received: from smtp01.cdmon.com ([212.36.75.232]:63292 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXJXKcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:32:23 -0400
X-Greylist: delayed 2199 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 06:32:22 EDT
Date: Wed, 24 Oct 2007 11:56:02 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: libata PATA status for VIA 8237
Message-ID: <20071024095602.GA2607@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

I'm thinking about switching fully to libata in the near future
(currently I'm using CONFIG_IDE for all my PATA drives, both hard disks
and DVD recorder), and I was wondering if PATA support for VIA8237 was
full or not. For what I've googled, it seems that it is usable both for
PATA and for SATA, but I want to be sure.

If I'm asking here is because I have SATA support for my VIA chipset
enabled in the kernel (CONFIG_SATA_VIA), but I'm getting these messages:

    sata_via 0000:00:0c.0: version 2.0
    sata_via 0000:00:0c.0: routed to hard irq line 10
    ata1: SATA max UDMA/133 cmd 0xFE00 ctl 0xFE0A bmdma 0xFA00 irq 10
    ata2: SATA max UDMA/133 cmd 0xFD00 ctl 0xFD0A bmdma 0xFA08 irq 10
    scsi0 : sata_via
    ata1: SATA link down (SStatus 0 SControl 310)
>>  ATA: abnormal status 0x7F on port 0xFE07
    scsi1 : sata_via
    ata2: SATA link down (SStatus 0 SControl 310)
>>  ATA: abnormal status 0x7F on port 0xFD07
    sata_via 0000:00:0f.0: routed to hard irq line 11
    ata3: SATA max UDMA/133 cmd 0xF900 ctl 0xF802 bmdma 0xF500 irq 11
    ata4: SATA max UDMA/133 cmd 0xF700 ctl 0xF602 bmdma 0xF508 irq 11
    scsi2 : sata_via
    ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
>>  ATA: abnormal status 0x7F on port 0xF907
    scsi3 : sata_via
    ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
>>  ATA: abnormal status 0x7F on port 0xF707

Since I don't have any SATA disk on my system, I haven't given any
importance to these messages, but now that I want to switch to libata,
I'm concerned. I don't understand the marked messages, and I don't know
if they have to do with CONFIG_IDE and CONFIG_BLK_DEV_VIA82CXXX being
enabled together with CONFIG_SATA_VIA.

My kernel is 2.6.20.18 and my mobo has three PATA busses and four SATA
ports (which I think they are ata1-ata4 in the messages above. I don't
know why only two of them are marked as 1.5Gbps, according to the mobo
manual, all four are 1.5Gbps).

Thanks a lot in advance and feel free to ask if you need more
information about hardware or software.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
We are waiting for 13 Feb 2009 23:31:30 +0000 ...
