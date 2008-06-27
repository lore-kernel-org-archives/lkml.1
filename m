Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYF0IGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYF0IGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYF0IGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:06:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYF0IGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:06:30 -0400
Message-ID: <48649F84.4090501@firstfloor.org>
Date: Fri, 27 Jun 2008 10:06:28 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com>	 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>	 <4863DB29.1020304@firstfloor.org>	 <20080626185254.GA12416@dirshya.in.ibm.com>	 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>	 <48640C04.9020600@firstfloor.org>	 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>	 <48641A7D.6080204@firstfloor.org> <1214553090.2801.7.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1214553090.2801.7.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> There used to be an option for them to also up on niced load. If that

You could always force socket power saving mode to off globally too if
you don't want it at all.

> disappeared then I'd call that a huge usability regression. Basically
> making ondemand useless.
> 
> /me checks,..
> 
> Yeah, on F9, my opteron runs at 1GHz when idle, but when I start distcc,
> which like said runs on nice 19, the cpu speed goes up to 2.4GHz.

Ok distcc is a special case, but it doesn't apply to a lot of other
processes (do you really want your CPU to crank up for "updatedb" or
beagle or some backup job for example?)

Perhaps there should be a way to express this in priorities?
"I am low priority, but want to be work conserving if the system
is idle"

The group scheduler is changing the semantics of nice completely
anyways, so so more changes could be applied.

-Andi
