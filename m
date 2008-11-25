Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYKYSvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYKYSvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYKYSve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:51:34 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:51463 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbYKYSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:51:33 -0500
Message-ID: <492C491B.8060103@nortel.com>
Date: Tue, 25 Nov 2008 12:51:07 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when the
 task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED isn't
 set
References: <20081120061854.GA4349@in.ibm.com>	 <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com>	 <1227515526.7685.21861.camel@twins>	 <20081124084644.GA26526@linux.vnet.ibm.com>	 <1227517575.7685.21906.camel@twins>  <492AC715.9080602@nortel.com> <1227540990.4259.296.camel@twins>
In-Reply-To: <1227540990.4259.296.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2008 18:51:12.0153 (UTC) FILETIME=[C9532890:01C94F2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-11-24 at 09:24 -0600, Chris Friesen wrote:
> 
>>Peter Zijlstra wrote:

>>>Furthermore your statement shows another misconception, a group of
>>>ungrouped tasks doesn't make sense.
>>
>>Arguably there is such a group, which is "the set of all RT tasks".
> 
> 
> Sure, I understand that, and in fact that's how its implemented, no
> group is still one group (which is how you can bootstrap math from
> group/set theory).
> 
> But its not a manageable group in the cgroup sense, its just the
> collection of RT tasks.

True, but it would be valuable to have statistics for how much cpu time 
the RT tasks are consuming.

Chris
