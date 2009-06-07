Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZFGQP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZFGQP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZFGQPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:15:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55319 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZFGQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:15:48 -0400
Date: Sun, 7 Jun 2009 21:44:40 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090607161440.GA3609@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com> <20090605081651.GD3872@in.ibm.com> <4A2B5881.9060204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2B5881.9060204@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 09:04:49AM +0300, Avi Kivity wrote:
> Bharata B Rao wrote:
>> On Fri, Jun 05, 2009 at 09:01:50AM +0300, Avi Kivity wrote:
>>   
>>> Bharata B Rao wrote:
>>>     
>>>> But could there be client models where you are required to strictly
>>>> adhere to the limit within the bandwidth and not provide more (by advancing
>>>> the bandwidth period) in the presence of idle cycles ?
>>>>         
>>> That's the limit part.  I'd like to be able to specify limits and   
>>> guarantees on the same host and for the same groups; I don't think 
>>> that  works when you advance the bandwidth period.
>>>
>>> I think we need to treat guarantees as first-class goals, not 
>>> something  derived from limits (in fact I think guarantees are more 
>>> useful as they  can be used to provide SLAs).
>>>     
>>
>> I agree that guarantees are important, but I am not sure about
>>
>> 1. specifying both limits and guarantees for groups and
>>   
>
> Why would you allow specifying a lower bound for cpu usage (a  
> guarantee), and upper bound (a limit), but not both?

I was saying that we specify only limits and not guarantees since it
can be worked out from limits. Initial thinking was that the kernel will
be made aware of only limits and users could set the limits appropriately
to obtain the desired guarantees. I understand your concerns/objections
on this and we will address this in our next version of RFC as Balbir said.

Regards,
Bharata.
