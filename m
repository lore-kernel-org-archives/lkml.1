Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZFEI2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZFEI2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZFEIRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:17:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37473 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557AbZFEIRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:17:51 -0400
Date: Fri, 5 Jun 2009 13:46:51 +0530
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
Message-ID: <20090605081651.GD3872@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28B4CE.4010004@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 09:01:50AM +0300, Avi Kivity wrote:
> Bharata B Rao wrote:
>>
>> But could there be client models where you are required to strictly
>> adhere to the limit within the bandwidth and not provide more (by advancing
>> the bandwidth period) in the presence of idle cycles ?
>>   
>
> That's the limit part.  I'd like to be able to specify limits and  
> guarantees on the same host and for the same groups; I don't think that  
> works when you advance the bandwidth period.
>
> I think we need to treat guarantees as first-class goals, not something  
> derived from limits (in fact I think guarantees are more useful as they  
> can be used to provide SLAs).

I agree that guarantees are important, but I am not sure about

1. specifying both limits and guarantees for groups and
2. not deriving guarantees from limits.

Guarantees are met by some form of throttling or limiting and hence I think
limiting should drive the guarantees.

Regards,
Bharata.
