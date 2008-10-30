Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYJ3Rtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYJ3Rtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYJ3Rth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:49:37 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49295 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756133AbYJ3Rtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:49:36 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 13:49:35 EDT
Message-ID: <20081030174925.36023f19jy3o832t@feanor.sssup.it>
Date: Thu, 30 Oct 2008 17:49:25 +0100
From: faggioli@gandalf.sssup.it
To: Peter Zijlstra <peterz@infradead.org>
Cc: henrik@austad.us, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       trimarchimichael@yahoo.it
Subject: Re: Rearranging layout of code in the scheduler
References: <200810281634.11285.henrik@austad.us>
	<1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1225212627.15763.16.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.3) / FreeBSD-7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Zijlstra <peterz@infradead.org>:
>> Before I dive in, I should probably justify my motivations for writing
>> this email. I'm working away on implementing an EDF scheduler for real
>> time tasks in the kernel. This again leads to hacking at the existing
>> source as I'm not about to toss out the entire scheduler - just replace
>> (by some Kconfig switch) the RR/FIFO classes. As to why I'm looking at
>> EDF, I think the answer to that is a bit too long (and not appropriate
>> for this email anyway) so I'll leave that part out.
Well, I understand that, but it could be interesting... At least to me. :-)

> You and a few other folks.
Yes, here we are! :-)

We also have some code, but it still is highly experimental and we are  
deeply rearranging it.

> The most interesting part of EDF is not the
> actual scheduler itself (although there are fun issues with that as
> well), but extending the Priority Inheritance framework to deal with all
> the fun cases that come with EDF.
The main problem is that, especially to deal with SMP systems, we also  
need to investigate theoretical issues and find out what the best  
approach could be.

> Well, adding a sched_class, no need to replace anything besides that.
>
I'm not saying anything in possible sched.c and sched_{fair|rt}.c code  
rearranging, I also only wonder why replacing fixed priority RT  
scheduling with EDF.

I think they both could be in... Maybe we can discuss on where, I mean  
on which position, in the linked list of scheduling classes, to put  
each of them.

Regards,
Dario

Thanks for the Cc. Peter, I also added Fabio and Michael that, you  
know, are working to this thing. :-)

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
