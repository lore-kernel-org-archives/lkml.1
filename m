Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXGOB2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXGOB2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXGOB17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:27:59 -0400
Received: from opinicus.com ([24.73.193.242]:54196 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755584AbXGOB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:27:59 -0400
Message-ID: <469977EF.7050709@opinicus.com>
Date: Sat, 14 Jul 2007 21:27:11 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com>	<m33azrt5a6.fsf@maximus.localdomain> <46995998.70706@opinicus.com> <m3d4yuczqw.fsf@maximus.localdomain>
In-Reply-To: <m3d4yuczqw.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:

>William Montgomery <william@opinicus.com> writes:
>
>  
>
>>I am using a PCI analyzer and it shows the bus in an idle state after
>>the lockup.  The PCI transactions just prior to the lockup show a
>>couple of interrupts from the card which appear to be handled
>>correctly.  Anything I should be looking for in particular?
>>    
>>
>
>I'd try to check with other machine using "secondary" bus slot.
>BTW: Are you able to analyze the "primary" bus transactions while
>using the card in "secondary" bus? Perhaps there is something
>wrong in front of the motherboard bridge?
>
>A broken motherboard may be hard to diagnose, unfortunately.
>
>Can you post something like "lspci -vv" taken on both machines?
>  
>
I will post more info on Monday when I am able to power them up.

I'm not so sure the motherboard is broken, I am leaning more towards a 
misconfigured
bridge.  This computer is a 4U 19 inch rackmount chassis with a PCMIG 
CPU and a 12 slot PCI backplane.  I have done a lot of testing with this 
box trying to characterize this problem.  In one case I have put 3 Intel 
PRO 100S NICs on the secondary PCI bus and they ran under heavy stress 
test loads overnight.  The 4 port NIC seems to be the only card that 
doesnt want to cooperate.
