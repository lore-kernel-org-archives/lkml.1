Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYFZPD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYFZPD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYFZPDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:03:15 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:52086 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102AbYFZPDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:03:13 -0400
Message-ID: <4863AF57.3040005@linux.vnet.ibm.com>
Date: Thu, 26 Jun 2008 20:31:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, svaidy@linux.vnet.ibm.com,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
References: <20080625191100.GI21892@dirshya.in.ibm.com> <87k5gcqpbm.fsf@basil.nowhere.org>
In-Reply-To: <87k5gcqpbm.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> writes:
>> The idea being proposed is to enhance the tunable with varied degrees
>> of consolidation that can work best for different workload
>> characteristics.  echo 2 > /sys/.../sched_mc_power_savings could
>> enable more aggressive consolidation than the default.
> 
> It would be better to fix the single power saving default to work
> better with bursty workloads too than to add more tunables. Tunables
> are basically "we give up, let's push the problem to the user"
> which is not nice. I suspect a lot of users won't even know if their
> workloads are bursty or not.  Or they might have workloads which
> are both bursty and not bursty.
> 
> Or did you try that and failed?
> 

A user could be an application and certain applications can predict their
workload. For example, a database, a file indexer, etc can predict their workload.

Policies are best known in user land and the best controlled from there.
Consider a case where the end user might select a performance based policy or a
policy to aggressively save power (during peak tariff times). With
virtualization, the whole concept of application is changing, the OS by itself
could be an application :)


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
