Return-Path: <linux-kernel-owner+w=401wt.eu-S935501AbXJPTD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935501AbXJPTD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762799AbXJPTDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:03:48 -0400
Received: from client062.sevenl.net ([66.241.137.62]:3888 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760042AbXJPTDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:03:48 -0400
Message-ID: <47150B06.3040306@pcburn.com>
Date: Tue, 16 Oct 2007 15:03:34 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Andrey Panin <pazke@donpac.ru>
CC: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru>
In-Reply-To: <20071012120826.GB23378@pazke.donpac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin wrote:
> On 284, 10 11, 2007 at 01:02:12PM -0400, Chris Bergeron wrote:
>   
>> Andrey Panin wrote:
>>     
>>> On 278, 10 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
>>>   
>>>       
>>>> Hello all,
>>>>
>>>> I've just installed a multiport serial card released by an outfit called 
>>>> Syba.  This is an 8 port serial-only card with an Octopus style breakout 
>>>> cable.  The main chipset on it is an ITE IT8871F.
>>>>     
>>>>         
>>> Are you sure ? IIRC IT887x are PCI-ISA bridges with additional periphery
>>> and your lspci shows PLX chip. Can you send complete lspci -vv output ?
>>> Output of dmesg could be useful too.
>>>
>>>       
>> I'm sure that's what it says on the largest chip on the PCI card.  It could 
>> be that the other two chips are more relevant... the numbers from them are 
>> included below.
>>
>> I've posted up a quick text only page with the diagnostic information from 
>> the system (full dmesg, lspci, etc) plus links to pictures of the board 
>> (since others might see something important that I'm not aware of).  You 
>> can access that at 
>> http://pcburn.com/files/Syba_serial_controller/index.html
>>     
>
> Can you try an attached patch ? I hope it should at least detect UARTs on 
> your board. Be ready that baudrate could be wrong, because we do not know
> what frequency is used to clock these UARTs.
>
>   
Alright,finally had another machine to try the attached patch.  I get an 
odd error regarding IRQ 17:

"irq 17: nobody cared (try booting with the "irqpoll" option)"

along with a long error message (but the kernel continues to load).  
Aside from that the ports now allow me to run a getty on them and the 
DTR line lights up on my serial tester (as it does with a working port) 
but the device on the other end doesn't function.

I've updated the web page with lspci -vv and dmesg output.  I can also 
post it here if that's desirable, just figured I'd save everyone the 
inbox flooding :).

-- Chris

