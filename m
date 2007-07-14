Return-Path: <linux-kernel-owner+w=401wt.eu-S1764698AbXGNBxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764698AbXGNBxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbXGNBw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:52:59 -0400
Received: from qsrv03sl.mx.bigpond.com ([144.140.92.183]:45703 "EHLO
	qsrv03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbXGNBw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:52:58 -0400
Message-ID: <46981855.8040904@bigpond.net.au>
Date: Sat, 14 Jul 2007 10:27:01 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       jim.houston@ccur.com, joe.korty@ccur.com, rostedt@goodmis.org,
       tglx@linutronix.de, dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22 available
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com> <20070712130958.GB17494@elte.hu> <46971ADC.3030700@bigpond.net.au> <200707130443.11356.gene.heskett@gmail.com>
In-Reply-To: <200707130443.11356.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.170.68.8] using ID pwil3058@bigpond.net.au at Sat, 14 Jul 2007 00:27:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Friday 13 July 2007, Peter Williams wrote:
>> Ingo Molnar wrote:
>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>> On Thu, 2007-07-12 at 14:07 +0200, Ingo Molnar wrote:
>>>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>>>> Hi Ingo, Thomas, and the greater linux-rt community,
>>>>>>
>>>>>> 	I just wanted to let you guys know that our team has a port of
>>>>>> the 21.5-rt20 patch for the 2.6.22 kernel available. [...]
>>>>> great! We had the upstream -rt port to .22 in the works too, it was just
>>>>> held up by the hpet breakage - which Thomas managed to fix earlier
>>>>> today. I've released the 2.6.22.1-rt1 patch to the usual place:
>>>>>
>>>>>     http://redhat.com/~mingo/realtime-preempt/
>>>> Thats awesome, Ingo!  Thanks!  Could you publish a broken out version
>>>> as well?  We found it extremely valuable to be able to bisect this
>>>> beast while working on the 21-22 port.
>>> we are working on something in this area :) Stay tuned ...
>> I've just been reviewing these patches and have spotted an error in the
>> file mm/slob.c at lines 500-501 whereby a non existent variable "c" is
>> referenced.  The attached patch is a proposed fix to the problem.
> 
> Could this explain why 2.6.22.1-rt1 seems to use a lot of swap?  I've been as 
> high as 570 megs into swap, currently at 286megs after doing a 
> swapoff --a;swapon -a about 8 hours ago.

No.  This problem would have caused the build to fail if slob was
configured.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
 -- Ambrose Bierce
