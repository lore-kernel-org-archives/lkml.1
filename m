Return-Path: <linux-kernel-owner+w=401wt.eu-S932557AbXGNXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbXGNXSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbXGNXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:18:32 -0400
Received: from opinicus.com ([24.73.193.242]:53644 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753838AbXGNXSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:18:32 -0400
Message-ID: <46995998.70706@opinicus.com>
Date: Sat, 14 Jul 2007 19:17:44 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com> <m33azrt5a6.fsf@maximus.localdomain>
In-Reply-To: <m33azrt5a6.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:

>William Montgomery <william@opinicus.com> writes:
>
>  
>
>>In an earlier post to the list I described a hard lockup condition
>>that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
>>a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
>>and occurs on 2 out of 3 computers.
>>
>>Further testing has revealed that the lockup can be prevented on all
>>computers by making sure the card is installed on the primary PCI bus.
>>If the card is installed in a slot on the secondary PCI bus (behind a
>>PCI to PCI bridge) the lockup occurs.
>>    
>>
>
>Does the machine #3 have a PCI slot connected to a "secondary" bus?
>Have you tried with any other machine with a secondary bus?
>
>  
>
The #3 machine doesn't have a secondary bus.  #1 and #2 are from 2 
different vendors (#1 Advantech - #2 Axiomtek) and I havent tried any 
othe machines.

>>Are there any PCI tuning registers that I can tweak to get around
>>this problem?  Any changes I could make to the e100 driver to fix this?
>>    
>>
>
>Could be a hardware/BIOS problem on machines #1 and #2. Could be
>a Linux bug as well, though similar configurations are known to work
>fine. I don't think it has anything to do with IRQs.
>
>Perhaps it doesn't like a bridge (on the card) behind a bridge
>(on the motherboard). I would test with another multiport card
>such as old DLink DFE-570TX (using a DEC 21150 bridge and four
>21143 Ethernet chips).
>
>I'd probably use some PCI analyzer or, at least, I'd check
>the bus state with a multimeter.
>  
>
The #1 and #2 machines are known to work with an older Adaptec ANA-62044 
4port NIC (tulip based) with an onboard Intel 21154 bridge chip.  The 
card I am having problems with uses an onboard Hint Corp HB6 Universal 
PCI-PCI bridge.

I am using a PCI analyzer and it shows the bus in an idle state after 
the lockup.  The PCI transactions just prior to the lockup show a couple 
of interrupts from the card which appear to be handled correctly.  
Anything I should be looking for in particular?

