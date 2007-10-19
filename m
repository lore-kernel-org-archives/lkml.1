Return-Path: <linux-kernel-owner+w=401wt.eu-S1765386AbXJSOSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765386AbXJSOSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbXJSOSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:18:15 -0400
Received: from mail66.opentransfer.com ([76.162.254.66]:45545 "HELO
	mail66.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754802AbXJSOSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:18:14 -0400
Message-ID: <002301c8125a$d50c7860$4400a8c0@YOUR9EC669DBD1>
From: <kyle@xtechgear.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Date: Fri, 19 Oct 2007 10:17:50 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I also have an 8 port PCI serial card with the 8871 chip on it and a 
breakout cable.  It is identified as such on my machine:

01:02.0 Serial controller: PLX Technology, Inc. Unknown device 9016 (rev 01) 
(prog-if 02 [16550])
        Subsystem: Unknown device 544e:0008
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 9
        Region 0: I/O ports at b800 [disabled] [size=64]
        Region 1: I/O ports at b400 [disabled] [size=16]
        Region 2: I/O ports at b000 [disabled] [size=16]
        Region 3: Memory at ff8fe000 (32-bit, non-prefetchable) [disabled] 
[size=4K]
        Region 4: Memory at ff8fd000 (32-bit, non-prefetchable) [disabled] 
[size=4K]
        Region 5: Memory at ff8fc000 (32-bit, non-prefetchable) [disabled] 
[size=4K]

There was also a driver cd included with my card, and I've placed the 
drivers at:

http://www.sasseriansection.com/media/files/it8871.tar.gz

I have not been able to get the drivers to install properly into my 2.6.18 
kernel though.

Looking at the files and whatnot, it does seem that the suspicions posted 
here were correct.  That the card is ran via a parallel port, and through 
this parallel port the uarts are accessed.  The drivers seem to basically be 
a modified parport_pc module.  The drivers that came with the card are for a 
2.4 kernel though.

I also found a couple references to work on some kernel modules at 
http://lkml.org/lkml/2007/8/10/404 regarding adding 8871 support, but 
haven't been able to do much with it.

Hope this information is helpful to someone, and if possible please CC me on 
any additional discussions regarding this card.
-------------
Kyle Sasser 

