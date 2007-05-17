Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXEQCLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXEQCLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbXEQCKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:10:55 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:42239 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbXEQCKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:10:55 -0400
Date: Wed, 16 May 2007 22:10:34 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the
 LSR and MSR
In-reply-to: <464B4235.5030405@acm.org>
To: Corey Minyard <minyard@acm.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <200705162210.34739.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070504131532.GA12265@localdomain>
 <20070506181422.GB21158@flint.arm.linux.org.uk> <464B4235.5030405@acm.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007, Corey Minyard wrote:
>Russell King wrote:
>> On Sun, May 06, 2007 at 12:58:25PM -0400, Gene Heskett wrote:
>>> [long message snipped]
>>>
>>> Thanks for your patience Corey.
>>
>> So, in one sentence or preferably one word, did Corey's patch cause a
>> regression?
>
>>From what Gene said, I think the final outcome is that this patch didn't
>seem to make any difference. It looks to me that the problems were
>elsewhere.
>
>So what's the state of this patch?
>
>Thanks,
>
>-corey

Gene here.  My impression was that this patch did help in that it appeared to 
clean up what was thought to be less than optimum code in that area.  There 
were a few times when it didn't seem to take quite as many kills and restarts 
of that ill-coded proprietary daemon to make things behave.

OTOH, I get the very strong impression there is another, more serious buglet 
someplace else that does a pretty good job of masking any black and white 
comparisons one might make about this patch.

Older code, as in 4 or 5 minor kernel versions back, appeared to work 
correctly, either on a serial port, or a usb port with a pl2303, if one could 
tolerate the miss-fires it did occasionally.  Now of course the pl2303 seems 
to be broken, both of the ones I have quit working at all with 2.6.21 final.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
* |Rain| prepares for polygon soup
<|Rain|> sweet merciful crap, it works?
* |Rain| faints
