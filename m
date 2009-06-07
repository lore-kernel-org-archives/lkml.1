Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZFGGLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZFGGLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 02:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZFGGKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 02:10:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZFGGKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 02:10:52 -0400
Message-ID: <4A2B597D.4020604@redhat.com>
Date: Sun, 07 Jun 2009 09:09:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090605030309.GA3872@in.ibm.com> <4A28A2AB.3060108@redhat.com>	 <20090605044946.GA11755@balbir.in.ibm.com>	 <20090605051050.GB11755@balbir.in.ibm.com>	 <4A28AB67.7040800@redhat.com>	 <20090605052755.GE11755@balbir.in.ibm.com>	 <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com>	 <20090605093947.GJ11755@balbir.in.ibm.com>	 <4A291A2F.3090201@redhat.com> <661de9470906050642s7774d601l53e366c77ffa7475@mail.gmail.com>
In-Reply-To: <661de9470906050642s7774d601l53e366c77ffa7475@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> I am selling virtual private servers.  A 10% cpu share costs $x/month, and I
>> guarantee you'll get that 10%, or your money back.  On the other hand, I
>> want to limit cpu usage to that 10% (maybe a little more) so people don't
>> buy 10% shares and use 100% on my underutilized servers.  If they want 100%,
>> let them pay for 100%.
>>     
>
> Excellent examples, we've covered them in the RFC, could you see if we
> missed anything in terms of use cases? The real question is do we care
> enough to build hard limits control into the CFS group scheduler. I
> believe we should.
>   

You only cover the limit part.  Guarantees are left as an exercise to 
the reader.

I don't think implementing guarantees via limits is workable as it 
causes the cpu to be idled unnecessarily.

>>> Even limits are useful for SLA's since your b/w available changes
>>> quite drastically as we add or remove groups. There are other use
>>> cases for limits as well
>>>       
>> SLAs are specified in terms of guarantees on a service, not on limits on
>> others.  If we could use limits to provide guarantees, that would be fine,
>> but it doesn't quite work out.
>>     
>
> To be honest, I would disagree here, specifically if you start
> comparing how you would build guarantees in the kernel and compare it
> with the proposed approach. I don't want to harp on the technicality,
> but point out the feasibility for people who care for lower end of the
> guarantee without requiring density. I think the real technical
> discussion should be on here are the use cases, lets agree on the need
> for the feature and go ahead and start prototyping the feature.
>   

I don't understand.  Are you saying implementing guarantees is too complex?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

