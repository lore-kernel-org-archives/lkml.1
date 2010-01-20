Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762Ab0ATWof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0ATWof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303Ab0ATWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:44:34 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51982 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0ATWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:44:33 -0500
Message-ID: <4B578731.2060709@austin.ibm.com>
Date: Wed, 20 Jan 2010 16:44:01 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop> <1264020517.4283.1117.camel@laptop>
In-Reply-To: <1264020517.4283.1117.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2010-01-20 at 14:04 -0600, Joel Schopp wrote:
>   
>> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
>> there is performance benefit to idling the higher numbered threads in
>> the core.  
>>     
>
> So this is an actual performance improvement, not only power savings?
>   
Yes.

>
>
> And you just wrecked x86 ;-)
>
> It has an smt_power implementation that tries to measure smt gains using
> aperf/mperf, trouble is that this represents the actual performance not
> the capacity. This has the problem that when idle it represents 0
> capacity and will not attract work.
>
> Coming up with something that actually works there is on the todo list,
> I was thinking perhaps temporal maximums from !idle.
>
> So if you want to go with this, you'll need to stub out
> arch/x86/kernel/cpu/sched.c
>   

OK.  Guess I now will have a 3 patch series, with a patch to stub out 
the x86 broken version.

Care to take Gautham's bugfix patch (patch 1/2) now, since it just fixes 
a bug?  You'll need it if you ever try to make the x86 broken version work.
