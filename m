Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbXCSDDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbXCSDDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 23:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933783AbXCSDDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 23:03:32 -0400
Received: from dxa01.wellsfargo.com ([151.151.65.117]:47921 "EHLO
	dxa01.wellsfargo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbXCSDDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 23:03:32 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: 1000xf bus problem
Date: Sun, 18 Mar 2007 22:03:21 -0500
Message-ID: <E8C008223DD5F64485DFBDF6D4B7F71D0289EDC1@msgswbmnmsp25.wellsfargo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 1000xf bus problem
Thread-Index: Acdpn3HNfN88cNyVQe2aSwNba14s4wAM0GlQ
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no> <45FD95CD.2030403@shaw.ca> <45FDA668.1090202@intel.com>
From: <Greg.Chandler@wellsfargo.com>
To: <auke-jan.h.kok@intel.com>, <hancockr@shaw.ca>
Cc: <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 19 Mar 2007 03:03:21.0900 (UTC) FILETIME=[272376C0:01C769D3]
X-WFMX: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If you mean dmesg it says this:
e1000: 0000:0d:02.0: e1000_probe: (PCI-X:100MHz:64-bit)  {macaddress}

That's weird... dmesg shows one thing, lspci shows another, and my data
transfers seem to point to the lspci info...

Any idea which I should trust?


-----Original Message-----
From: Kok, Auke [mailto:auke-jan.h.kok@intel.com] 
Sent: Sunday, March 18, 2007 3:52 PM
To: Robert Hancock
Cc: Chandler, Greg; linux-kernel; e1000-devel@lists.sourceforge.net
Subject: Re: 1000xf bus problem

Robert Hancock wrote:
> Greg.Chandler@wellsfargo.com wrote:
>> I'm running a e1000xf adapter in a 64-bit/100Mhz PCI slot.  The intel

>> site shows this is a supported config for the card, but linux is 
>> pulling this info:
>>
>> ed:02.0 Ethernet controller: Intel Corporation 82544EI Gigabit 
>> Ethernet Controller (Fiber) (rev 02)
>> 	Subsystem: Intel Corporation PRO/1000 XF Server Adapter
>> 	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 18
>> 	Memory at f7fe0000 (64-bit, non-prefetchable) [size=128K]
>>       Memory at f7fc0000 (64-bit, non-prefetchable) [size=128K]
>>       I/O ports at 7000 [size=32]
>>       [virtual] Expansion ROM at f10a0000 [disabled] [size=128K]
>>       Capabilities: [dc] Power Management version 2
>>       Capabilities: [e4] PCI-X non-bridge device
>>       Capabilities: [f0] Message Signalled Interrupts: 64bit+ 
>> Queue=0/0
>> Enable-
>>
>> My thoughput tests show it is definitely not running at the 100Mhz 
>> bus rate is should be capable of.
> 
> How are you determining this?
> 
>  > Any ideas on how to make it work at full speed?

what is the dmesh output of e1000 ? it should show you what the card
itself detects (at least the newer drivers since 7.0.x all do). This may
provide some clues as to what the card has detected.

Auke


