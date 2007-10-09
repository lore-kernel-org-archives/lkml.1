Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXJIT0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXJIT0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXJIT0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:26:11 -0400
Received: from client062.sevenl.net ([66.241.137.62]:2464 "EHLO pcburn.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbXJIT0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:26:10 -0400
Message-ID: <470BD5C1.4010804@pcburn.com>
Date: Tue, 09 Oct 2007 15:25:53 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
References: <4706AD19.4040605@pcburn.com> <20071009181413.GD4003@csclub.uwaterloo.ca>
In-Reply-To: <20071009181413.GD4003@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Fri, Oct 05, 2007 at 05:31:05PM -0400, Chris Bergeron wrote:
>   
>> I've just installed a multiport serial card released by an outfit called 
>> Syba.  This is an 8 port serial-only card with an Octopus style breakout 
>> cable.  The main chipset on it is an ITE IT8871F.
>>     
>
> Well 8250_pci.c mentions IT8871, so it is probably 8250 style in
> interface then.
>
>   
That's what I had thought too after a quick LKML search.  Doing a bit 
more research (I'm starting to think the IT8871F on the chip is 
misleading) it looks like that support is for a single parallel multi 
I/O card (with the other 887x cards being serial/parport PCI cards).

>> I've got two questions on this: Is there a driver I should try force 
>> loading on it (and if so, what options to use)?  and is there any useful 
>> testing I can do to report back to the LKML on this card?
>>     
>
> How many serial ports is your kernel configured to use?
>   
The kernel I'm using has 16 for both the NR_UARTS and RUNTIME_UARTS 
(these machines generally have a minimum of 4 ports).  dmesg doesn't 
show the kernel as recognizing the card and only ttyS0 and ttyS1 (the 
two onboard ports) show up on boot.

-- Chris
