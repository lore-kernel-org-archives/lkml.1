Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZABOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZABOv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZABOvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:51:14 -0500
Received: from 1wt.eu ([62.212.114.60]:1048 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZABOvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:51:13 -0500
Date: Fri, 2 Jan 2009 15:48:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: wtarreau@hera.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: BUG - 2.4.37 fealnx.c NETDEV WATCHDOG: eth0: transmit timed out
Message-ID: <20090102144813.GA13757@1wt.eu>
References: <3f9a31f40901020640m4a9a63caq9c96ba84ccd64d88@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901020640m4a9a63caq9c96ba84ccd64d88@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 02, 2009 at 08:10:50PM +0530, Jaswinder Singh Rajput wrote:
> Hello all,
> 
> Now I tested fealnx driver from 2.4.37 (2.4 git). I am still getting
> "NETDEV WATCHDOG: eth0: transmit timed out". Please let me know how
> can I fix this problem.

Well, I don't have such an adapter, but most of the times I encountered
a similar message with older 10/100 adapters, it was caused by a link
status issue or duplex mismatch.

Could you check with ethtool or mii-diag that the link status is correct
and 100 Mbps/Full duplex (assuming you're connected to a switch) ?

> fealnx.c:v2.51 Nov-17-2001
> eth0: 100/10M Ethernet PCI Adapter at 0x6200, 00:40:95:78:05:73, IRQ 11.
> 
> NETDEV WATCHDOG: eth0: transmit timed out
> eth0: Transmit timed out, status 00000000, resetting...
>   Rx ring c11bf000:  80000000 80000000 80000000 80000000 80000000
> 80000000 80000000 80000000 80000000 80000000 80000000 80000000
>   Tx ring c11be000:  80000000 80000000 80000000 80000000 0000 80000000
> NETDEV WATCHDOG: eth0: transmit timed out
> eth0: Transmit timed out, status 00000000, resetting...
>   Rx ring c11bf000:  80000000 80000000 80000000 80000000 80000000
> 80000000 80000000 80000000 80000000 80000000 80000000 80000000
>   Tx ring c11be000:  80000000 0000 80000000 80000000 80000000 80000000
> NETDEV WATCHDOG: eth0: transmit timed out
> eth0: Transmit timed out, status 00000000, resetting...
>   Rx ring c11bf000:  80000000 80000000 80000000 80000000 80000000
> 80000000 80000000 80000000 80000000 80000000 80000000 80000000
>   Tx ring c11be000:  80000000 80000000 80000000 80000000 80000000 0000
> 
> 
> 00:0a.0 Ethernet controller: MYSON Technology Inc: Unknown device 0803
> 	Subsystem: MYSON Technology Inc: Unknown device 0803
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (8000ns min, 16000ns max), cache line size 08
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: I/O ports at 6200 [size=256]
> 	Region 1: Memory at e1000000 (32-bit, non-prefetchable) [size=1K]
> 	Expansion ROM at <unassigned> [disabled] [size=64K]
> 	Capabilities: [88] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0-,D1+,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> Thank you,
> JSR

Regards,
Willy

