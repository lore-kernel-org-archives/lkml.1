Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbXCSCxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbXCSCxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 22:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933755AbXCSCxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 22:53:22 -0400
Received: from dxa00.wellsfargo.com ([151.151.65.115]:36373 "EHLO
	dxa00.wellsfargo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933738AbXCSCxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 22:53:21 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: 1000xf bus problem
Date: Sun, 18 Mar 2007 21:53:09 -0500
Message-ID: <E8C008223DD5F64485DFBDF6D4B7F71D0289EDBF@msgswbmnmsp25.wellsfargo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 1000xf bus problem
Thread-Index: AcdplYm1W7Pzc7WHR3e0wDvxSz3zxAAO+n3Q
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no> <45FD95CD.2030403@shaw.ca>
From: <Greg.Chandler@wellsfargo.com>
To: <hancockr@shaw.ca>, <linux-kernel@vger.kernel.org>
Cc: <e1000-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 19 Mar 2007 02:53:10.0234 (UTC) FILETIME=[BA8EA3A0:01C769D1]
X-WFMX: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


lspci -v shows the message below, and I am moving files between systems,
{from RAMdisk to RAMdisk} on idle machines.
The transfer rate is concurrent with just under the max throughput
capable on a 64-bit/66Mhz PCI socket.
 

-----Original Message-----
From: Robert Hancock [mailto:hancockr@shaw.ca] 
Sent: Sunday, March 18, 2007 2:41 PM
To: Chandler, Greg; linux-kernel
Cc: e1000-devel@lists.sourceforge.net
Subject: Re: 1000xf bus problem

Greg.Chandler@wellsfargo.com wrote:
> I'm running a e1000xf adapter in a 64-bit/100Mhz PCI slot.  The intel 
> site shows this is a supported config for the card, but linux is 
> pulling this info:
> 
> ed:02.0 Ethernet controller: Intel Corporation 82544EI Gigabit 
> Ethernet Controller (Fiber) (rev 02)
> 	Subsystem: Intel Corporation PRO/1000 XF Server Adapter
> 	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 18
> 	Memory at f7fe0000 (64-bit, non-prefetchable) [size=128K]
>       Memory at f7fc0000 (64-bit, non-prefetchable) [size=128K]
>       I/O ports at 7000 [size=32]
>       [virtual] Expansion ROM at f10a0000 [disabled] [size=128K]
>       Capabilities: [dc] Power Management version 2
>       Capabilities: [e4] PCI-X non-bridge device
>       Capabilities: [f0] Message Signalled Interrupts: 64bit+ 
> Queue=0/0
> Enable-
> 
> My thoughput tests show it is definitely not running at the 100Mhz bus

> rate is should be capable of.

How are you determining this?

 > Any ideas on how to make it work at full speed?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca Home Page:
http://www.roberthancock.com/



