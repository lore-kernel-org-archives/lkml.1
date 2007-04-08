Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbXDHREu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbXDHREu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 13:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXDHREu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 13:04:50 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:41307 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXDHREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 13:04:49 -0400
Date: Sun, 08 Apr 2007 13:04:47 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <20070408105849.GA15764@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704081304.48033.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <20070408104125.GB11123@elte.hu> <20070408105849.GA15764@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 April 2007, Ingo Molnar wrote:
>* Ingo Molnar <mingo@elte.hu> wrote:
>> > My question then, is why did it take a very public cat-fight to get
>> > this looked at and the code adjusted?  Its been what, nearly 2 years
>> > since Linus himself made a comment that this thing needed fixed.
>> > The fixes then done were of very little actual effectiveness and the
>> > situation then has gradually deteriorated since.
>>
>> this is pretty hard to get right, and the most objective way to change
>> it is to do it testcase-driven. FYI, interactivity tweaking has been
>> gradual, the last bigger round of interactivity changes were done a
>> year ago:
>
>and note that a year ago Mike did a larger patch too, not unlike his
>current patch - but we hoped that his smaller change would be sufficient
>- and nobody came along and said "i tested Mike's and the difference is
>significant on my system".

May I suggest that while it may have been noticeable, it was 
not 'significant', so we didn't sing praises and bow to mecca at the 
time.  I just thought that this is the way it was, till Cons patch proved 
otherwise for this  'desktop' user.  We were then, and still are, looking 
for the magic that lets it all load up and slow down in a linear feeling 
fashion.  Only those IRQ's that are fleeting and need serviced NOW should 
be exceptions to that rule.  AFAIAC, gzip can take its turn in the queue, 
getting no more time in proportion than any other process that wakes up 
in its slice and finds it has something to do, if nothing to do it should 
yield the floor immediately, and in any event be put back at the far end 
of the queue when its timeslice is over.  gzip in particular seems very 
reticent to give up the cpu at what should be the end of its timeslice.  
As it is, the IRQ's are being serviced, so no keystrokes are being lost, 
or very few, unlike the situation 2 years ago when whole sentences typed 
blind were on the missing list when x finally did get a chance to play 
catchup.

As a desktop user, I fail to understand any good reason why a keystroke 
typed can't be echoed to the screen within 200 milliseconds regardless of 
how many gzip -best's amdump may be running in the background.

I have a coco3, running nitros9 at a cpu clock rate of 1.79mhz with a 
1/10th second context switch, in the basement that CAN do that while 
assembling an executable with a separate process printing the listing of 
that assembly as it progresses.

Why can't linux?

>Which seems to suggest that the number of 
>problem-systems and worried users/developers isnt particularly large.

Again, may I suggest that this sort of behavior on the desktop is a 
contributing factor to that relative scarcity?

>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The meek will inherit the earth -- if that's OK with you.
