Return-Path: <linux-kernel-owner+w=401wt.eu-S1764023AbZAUPAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764023AbZAUPAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZAUPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:00:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57368 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763312AbZAUPAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:00:02 -0500
Message-ID: <49773848.4080409@redhat.com>
Date: Wed, 21 Jan 2009 16:59:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kevin Shanahan <kmshanah@ucwb.org.au>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>	 <1232410363.4768.21.camel@kulgan.wumi.org.au>	 <20090120113546.GA26571@elte.hu>	 <1232455343.4895.4.camel@kulgan.wumi.org.au>	 <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu>	 <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com>	 <49760E2D.2060109@redhat.com>	 <1232547932.4895.119.camel@kulgan.wumi.org.au>	 <49773275.3020203@redhat.com> <1232549502.4895.124.camel@kulgan.wumi.org.au>
In-Reply-To: <1232549502.4895.124.camel@kulgan.wumi.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Shanahan wrote:
>>> --- hermes-old.wumi.org.au ping statistics ---
>>> 900 packets transmitted, 900 received, 0% packet loss, time 899326ms
>>> rtt min/avg/max/mdev = 0.093/0.157/3.611/0.117 ms
>>>
>>> So, a _huge_ difference. But what does it mean?
>>>       
>> It means, a scheduling problem.  Can you run the latency tracer (which 
>> only works with realtime priority), so we can tell if it is (a) kvm 
>> failing to wake up the vcpu properly or (b) the scheduler delaying the 
>> vcpu from running.
>>     
>
> Sorry, but are you sure that's going to be useful?
>
> If it only works on realtime threads and I'm not seeing the problem when
> running kvm with realtime priority, is this going to tell you what you
> want to know?
>
> Not trying to be difficult, but that just didn't make sense to me.
>   

You're right, wasn't thinking properly.

This is a tough one.  I'll see if I can think of something.  Ingo, any 
ideas?

-- 
error compiling committee.c: too many arguments to function

