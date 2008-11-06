Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYKFGsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYKFGsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYKFGsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:48:15 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:42296 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYKFGsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:48:13 -0500
Message-ID: <491291F7.6030008@linux.vnet.ibm.com>
Date: Thu, 06 Nov 2008 12:13:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
References: <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com> <20081030171622.GA19872@linux.vnet.ibm.com> <20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com> <20081104124937.GB4898@in.ibm.com>
In-Reply-To: <20081104124937.GB4898@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Fri, Oct 31, 2008 at 09:40:41AM +0900, KAMEZAWA Hiroyuki wrote:
>> On Thu, 30 Oct 2008 22:46:22 +0530
>> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>>> I disagree. The child is a part of the parent's hierarchy, and therefore
>>> its usage should reflect in the parent's usage.
>>>
>> In my point of view, there is no big difference. It's just whether we need a tool
>> in userland or not. If there is no performance impact, I have no objections.
>>
>> One request from me is add Documentation/controllers/cpuacct.txt or some to explain
>> "what we see".
> 
> I am not sure which version (mine or Li Zefan's) Paul prefers. I am
> resending my patch anyway with documentation and performance numbers
> included. I don't see any significant improvement or degradation in
> hackbench, lmbench and volanomark numbers with this patch.
> 
> Regards,
> Bharata.
> 
> Add hierarchical accounting to cpu accounting controller and cpuacct
> documentation.
> 
> Currently, while charging the task's cputime to its accounting group,
> the accounting group hierarchy isn't updated. This patch charges the cputime
> of a task to its accounting group and all its parent accounting groups.
> 
> Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Reviewed-by: Paul Menage <menage@google.com>

Looks good and straight forward.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
