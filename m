Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZFENRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZFENRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZFENRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:17:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46029 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFENQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:16:59 -0400
Message-ID: <4A291A2F.3090201@redhat.com>
Date: Fri, 05 Jun 2009 16:14:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
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
References: <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com> <20090605093947.GJ11755@balbir.in.ibm.com>
In-Reply-To: <20090605093947.GJ11755@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> That's the limit part.  I'd like to be able to specify limits and  
>> guarantees on the same host and for the same groups; I don't think that  
>> works when you advance the bandwidth period.
>>     
>
> Yes, this feature needs to be configurable. But your use case for both
> limits and guarantees is interesting. We spoke to Peter and he was
> convinced only of the guarantee use case. Could you please help
> elaborate your use case, so that we can incorporate it into RFC v2 we
> send out. Peter is opposed to having hard limits and is convinced that
> they are not generally useful, so far I seen you and Paul say it is
> useful, any arguments you have or any +1 from you will help us. Peter
> I am not back stabbing you :)
>   

I am selling virtual private servers.  A 10% cpu share costs $x/month, 
and I guarantee you'll get that 10%, or your money back.  On the other 
hand, I want to limit cpu usage to that 10% (maybe a little more) so 
people don't buy 10% shares and use 100% on my underutilized servers.  
If they want 100%, let them pay for 100%.

>> I think we need to treat guarantees as first-class goals, not something  
>> derived from limits (in fact I think guarantees are more useful as they  
>> can be used to provide SLAs).
>>     
>
> Even limits are useful for SLA's since your b/w available changes
> quite drastically as we add or remove groups. There are other use
> cases for limits as well

SLAs are specified in terms of guarantees on a service, not on limits on 
others.  If we could use limits to provide guarantees, that would be 
fine, but it doesn't quite work out.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

