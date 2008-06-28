Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYF1Lfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYF1Lfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYF1Lfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:35:37 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:62591 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYF1Lfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:35:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncFADa/ZUh5LCP2/2dsb2JhbACBW68n
X-IronPort-AV: E=Sophos;i="4.27,719,1204464600"; 
   d="scan'208";a="146921080"
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
From: Tim Connors <tconnors@astro.swin.edu.au>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Mail-Copies-To: tconnors@astro.swin.edu.au
In-reply-to: <48649F84.4090501@firstfloor.org>
References: <20080625191100.GI21892@dirshya.in.ibm.com>
 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
 <4863DB29.1020304@firstfloor.org>
 <20080626185254.GA12416@dirshya.in.ibm.com>
 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
 <48640C04.9020600@firstfloor.org>
 <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
 <48641A7D.6080204@firstfloor.org>
 <1214553090.2801.7.camel@twins.programming.kicks-ass.net>
 <48649F84.4090501@firstfloor.org>
X-test-to: Andi Kleen <andi@firstfloor.org>
X-cc-to: Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
 balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
 Suresh B Siddha <suresh.b.siddha@intel.com>, Venkatesh Pallipadi
 <venkatesh.pallipadi@intel.com>, Ingo Molnar <mingo@elte.hu>, Vatsa
 <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
X-reply-to-bofh-messageid: <aJhc3-5JU-25@gated-at.bofh.it>
X-Editor: xemacsclientserver
X-EndlessSeptember: Sat Sep 5415 21:26:54 EST 1993
X-yes-we-have-no-x-yes-archive-today: NO
X-Face: m+g#A-,3D0}Ygy5KUD`Hckr=I9Au;w${NzE;Iz!6bOPqeX^]}KGt=l~r!8X|W~qv'`Ph4
 dZczj*obWD25|2+/a5.$#s23k"0$ekRhi,{cP,CUk=}qJ/I1acc
Message-ID: <12146524137149-twc@hexane.ssi.swin.edu.au>
Date: Sat, 28 Jun 2008 21:35:32 +1000
User-Agent: slrn/pre0.9.9-111 (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> said on Fri, 27 Jun 2008 10:06:28 +0200:
> Peter Zijlstra wrote:
> > disappeared then I'd call that a huge usability regression. Basically
> > making ondemand useless.
> > 
> > /me checks,..
> > 
> > Yeah, on F9, my opteron runs at 1GHz when idle, but when I start distcc,
> > which like said runs on nice 19, the cpu speed goes up to 2.4GHz.
> 
> Ok distcc is a special case, 

No it's not.  Most compute heavy jobs most people run would be better
off being done sooner rather than later, otherwise you might as well
go out and buy a 100MHz computer.  But most users also want "nice" to
do what was intended of it -- make one app not steal *any* CPU cycles
from another app that would really rather those CPU cycles right now
(yes, I know that long running CPU jobs theoretically become lower
priority so steal less, and in theory, there is no difference between
theory and practice.  But in practice, there is, and these long
running jobs still impact on desktop and ssh interactivity)

I end up nicing opera and firefox half the time because I'm sick of
their CPU leaks.  It doesn't mean I don't want them to finish their
screen updating sooner.
