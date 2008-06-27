Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYF0ItK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYF0ItK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbYF0Isy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:48:54 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:36323 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751688AbYF0Isw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:48:52 -0400
Date: Fri, 27 Jun 2008 14:20:32 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080627085032.GA17412@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com> <20080627170514.7A88.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080627170514.7A88.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2008-06-27 17:08:22]:

> Hi
> 
> > Advantages:
> > 
> > * Enterprise workloads on large hardware configurations may need
> >   aggressive consolidation strategy
> > * Performance impact on server is different from desktop or laptops.
> >   Interactivity is less of a concern on large enterprise servers while
> >   workload response times and performance per watt is more significant
> > * Aggressive power savings even with marginal performance penalty is
> >   is a useful tunable for servers since it may provide good
> >   performance-per-watt at low utilisation
> > * This tunable can influence other parts of scheduler like wakeup
> >   biasing for overall task consolidation  
> 
> I'd like to know how many saving power.
> if there are only small saving, I think this is not interesting feature.
> 
> Do you expect how many percentage saving?

The power savings depends on the number of sockets.  With the present
hardware on servers, we are seeing very small power savings.  However
deep sleep states and wide variation in CPU power consumption in
future will increase the percentage.  The percentage may be around
1 to 5 percent.  Given the system utilisation pattern and large number
of systems idle in a datacenter, this is not an insignificant number.
The power value can be significant in a 4 socket or larger system
configuration.

--Vaidy
