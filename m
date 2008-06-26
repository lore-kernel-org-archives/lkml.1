Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYFZWjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYFZWjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 18:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYFZWi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 18:38:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYFZWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 18:38:56 -0400
Message-ID: <48641A7D.6080204@firstfloor.org>
Date: Fri, 27 Jun 2008 00:38:53 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com>	 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>	 <4863DB29.1020304@firstfloor.org>	 <20080626185254.GA12416@dirshya.in.ibm.com>	 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>	 <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

>> And your workload manager could just nice processes. It should probably
>> do that anyways to tell ondemand you don't need full frequency.
> 
> Except that I want my nice 19 distcc processes to utilize as much cpu as
> possible, but just not bother any other stuff I might be doing...

They already won't do that if you run ondemand and cpufreq. It won't
crank up the frequency for niced processes.

Extending that existing policy to socket load balancing would be only
natural.

-Andi

