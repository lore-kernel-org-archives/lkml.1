Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXCBHR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXCBHR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXCBHR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:17:27 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:45652 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbXCBHR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:17:26 -0500
Date: Fri, 02 Mar 2007 02:16:39 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: belkin bulldog ups monitor vs 2.6.21-rc2
In-reply-to: <8cd998d50703012259l274b2d13k6da5048706c4664a@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Con Kolivas" <kernel@kolivas.org>
Message-id: <200703020216.40047.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703020042.17902.gene.heskett@gmail.com>
 <8cd998d50703012259l274b2d13k6da5048706c4664a@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007, Con Kolivas wrote:
>On 02/03/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> Greetings;
>>
>> I just rebooted to 2.6.21-rc2 and noted that getting x up and running
>> was about 15 seconds longer than usual.  When it got a bash shell
>> going I went to it and ran htop which showed that the bulldog monitor
>> was taking 90% of the cpu.  Killed it, then restarted it, but when I
>> ran the gui which ran fine and then stopped the gui, the daemon once
>> again went hog wild and had to be killed,  and I'm losing my kmail
>> composer focus for 30 seconds at a time now that amanda is making her
>> nightly run.
>>
>> There is nothing in the log about it other than from xinetd as it ran
>> the amanda server stuff.
>>
>> Not quite ready for prime time methinks.  Using the ck scheduler, this
>> is terrible performance, virtually no multitasking.  Back to
>> 2.6.20-ck1 in the morning if it lives the rest of the night.
>
>HI Gene.
>
>I'm not sure if you're saying here that the performance is terrible on
>2.6.21-rc2 only with the -ck scheduler, or only 2.6.21-rc2, or that
>2.6.20-ck1 is terrible or that it fixes the problem.  Can you please
>clarify this?

I miss-spoke above now that I read it again, sorry Con.  I think I thought 
my fingers had put 'Comparing' in front of the 'Using' above. This time 
of the night, my mind has been known to be running a chapter or more 
ahead of (or in some cases behind) my fingers.

2.6.20-ck1 runs great, 2.6.21-rc2 was not only a dog, it fed amanda a 
bunch of lsd via bad data from tar, so tar when told to do a level 1 
while 21-rc2 (without your patch) was running, it actually did a level 0, 
and predictably ran out of vtape.  /usr/pix didn't change over 7GB of its 
contents overnight, in fact nothing changed there yesterday, but tar sure 
went on a rampage.

Sorry about the confusion.  I'm back in 2.6.20-ck1 and everythings cool.

>Regards,
>-ck

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
