Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYF0Hvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYF0Hvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYF0Hvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:51:41 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:59386 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYF0Hvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:51:40 -0400
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <48641A7D.6080204@firstfloor.org>
References: <20080625191100.GI21892@dirshya.in.ibm.com>
	 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
	 <4863DB29.1020304@firstfloor.org>
	 <20080626185254.GA12416@dirshya.in.ibm.com>
	 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
	 <48640C04.9020600@firstfloor.org>
	 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
	 <48641A7D.6080204@firstfloor.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 09:51:30 +0200
Message-Id: <1214553090.2801.7.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 00:38 +0200, Andi Kleen wrote:
> Peter Zijlstra wrote:
> 
> >> And your workload manager could just nice processes. It should probably
> >> do that anyways to tell ondemand you don't need full frequency.
> > 
> > Except that I want my nice 19 distcc processes to utilize as much cpu as
> > possible, but just not bother any other stuff I might be doing...
> 
> They already won't do that if you run ondemand and cpufreq. It won't
> crank up the frequency for niced processes.
> 
> Extending that existing policy to socket load balancing would be only
> natural.

There used to be an option for them to also up on niced load. If that
disappeared then I'd call that a huge usability regression. Basically
making ondemand useless.

/me checks,..

Yeah, on F9, my opteron runs at 1GHz when idle, but when I start distcc,
which like said runs on nice 19, the cpu speed goes up to 2.4GHz.

And it uses the ondemand govenor.

