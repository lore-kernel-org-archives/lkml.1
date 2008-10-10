Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYJJBcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYJJBcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 21:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYJJBce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 21:32:34 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52073 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYJJBcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 21:32:33 -0400
Date: Fri, 10 Oct 2008 07:06:39 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v2 0/5] sched: modular find_busiest_group()
Message-ID: <20081010013639.GA4045@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com> <1223561968.7382.42.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1223561968.7382.42.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-10-09 16:19:28]:

> 
> Hi,
> 
> I've looked over the last posting, but so far failed to respond :/
> 
> While I like the clean-up, I'm atm a bit reluctant to apply, as I'm
> trying to rework the sched_domain stuff and the HT balancing and I'm not
> quite sure how this will interact with your patches.

Hi Peter,

Thanks for reviewing the changes.  I just wanted an initial feedback
before I spend too much time on this approach.  I am interested in HT
balancing stuff and I wanted to study the behaviour and improve the
power saving heuristics there as well.

> I hope to share my proposal (in talk - no patches yet) soonish (this
> weekend, early next week) so that we can discuss it.

I am looking forward to it.  We can definitely rework the
implementation to seamlessly take on power saving heuristics.

Thanks,
Vaidy
