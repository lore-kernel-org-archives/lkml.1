Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZFGGG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZFGGG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 02:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZFGGGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 02:06:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42293 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZFGGGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 02:06:47 -0400
Message-ID: <4A2B5881.9060204@redhat.com>
Date: Sun, 07 Jun 2009 09:04:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com> <20090605081651.GD3872@in.ibm.com>
In-Reply-To: <20090605081651.GD3872@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Fri, Jun 05, 2009 at 09:01:50AM +0300, Avi Kivity wrote:
>   
>> Bharata B Rao wrote:
>>     
>>> But could there be client models where you are required to strictly
>>> adhere to the limit within the bandwidth and not provide more (by advancing
>>> the bandwidth period) in the presence of idle cycles ?
>>>   
>>>       
>> That's the limit part.  I'd like to be able to specify limits and  
>> guarantees on the same host and for the same groups; I don't think that  
>> works when you advance the bandwidth period.
>>
>> I think we need to treat guarantees as first-class goals, not something  
>> derived from limits (in fact I think guarantees are more useful as they  
>> can be used to provide SLAs).
>>     
>
> I agree that guarantees are important, but I am not sure about
>
> 1. specifying both limits and guarantees for groups and
>   

Why would you allow specifying a lower bound for cpu usage (a 
guarantee), and upper bound (a limit), but not both?

> 2. not deriving guarantees from limits.
>
> Guarantees are met by some form of throttling or limiting and hence I think
> limiting should drive the guarantees

That would be fine if it didn't idle the cpu despite there being demand 
and available cpu power.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

