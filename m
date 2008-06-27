Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYF0M5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYF0M5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYF0M4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:56:52 -0400
Received: from brmea-mail-3.Sun.COM ([192.18.98.34]:47285 "EHLO
	brmea-mail-3.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYF0M4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:56:51 -0400
Date: Fri, 27 Jun 2008 08:54:12 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
In-reply-to: <20080627170514.7A88.KOSAKI.MOTOHIRO@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Reply-to: davecb@sun.com
Message-id: <4864E2F4.9080908@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080625191100.GI21892@dirshya.in.ibm.com>
 <20080627170514.7A88.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
> 
>>Advantages:
>>
>>* Enterprise workloads on large hardware configurations may need
>>  aggressive consolidation strategy
>>* Performance impact on server is different from desktop or laptops.
>>  Interactivity is less of a concern on large enterprise servers while
>>  workload response times and performance per watt is more significant
>>* Aggressive power savings even with marginal performance penalty is
>>  is a useful tunable for servers since it may provide good
>>  performance-per-watt at low utilisation
>>* This tunable can influence other parts of scheduler like wakeup
>>  biasing for overall task consolidation  
> 
> 
> I'd like to know how many saving power.
> if there are only small saving, I think this is not interesting feature.
> 
> Do you expect how many percentage saving?
> 

An experiment using DVFS on Xeon yeilded a 15-watt allowable reduction
even under running a considerable TPC-W workload.  Lesser loads allowed
a 40-watt (out of 160) reduction.  

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
