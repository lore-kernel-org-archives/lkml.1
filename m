Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXCRUxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXCRUxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXCRUxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:53:15 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:37378 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245AbXCRUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:53:14 -0400
Date: Sun, 18 Mar 2007 13:51:52 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: 1000xf bus problem
In-reply-to: <45FD95CD.2030403@shaw.ca>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Greg.Chandler@wellsfargo.com, linux-kernel <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
Message-id: <45FDA668.1090202@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no>
 <45FD95CD.2030403@shaw.ca>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Greg.Chandler@wellsfargo.com wrote:
>> I'm running a e1000xf adapter in a 64-bit/100Mhz PCI slot.  The intel
>> site shows this is a supported config for the card, but linux is pulling
>> this info:
>>
>> ed:02.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet
>> Controller (Fiber) (rev 02)
>> 	Subsystem: Intel Corporation PRO/1000 XF Server Adapter
>> 	Flags: bus master, 66Mhz, medium devsel, latency 64, IRQ 18
>> 	Memory at f7fe0000 (64-bit, non-prefetchable) [size=128K]
>>       Memory at f7fc0000 (64-bit, non-prefetchable) [size=128K]
>>       I/O ports at 7000 [size=32]
>>       [virtual] Expansion ROM at f10a0000 [disabled] [size=128K]
>>       Capabilities: [dc] Power Management version 2
>>       Capabilities: [e4] PCI-X non-bridge device
>>       Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0
>> Enable-
>>
>> My thoughput tests show it is definitely not running at the 100Mhz bus
>> rate is should be capable of.
> 
> How are you determining this?
> 
>  > Any ideas on how to make it work at full speed?

what is the dmesh output of e1000 ? it should show you what the card itself 
detects (at least the newer drivers since 7.0.x all do). This may provide some 
clues as to what the card has detected.

Auke
