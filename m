Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZFEGFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZFEGFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFEGFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:05:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45423 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZFEGFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:05:42 -0400
Message-ID: <4A28B539.3050001@redhat.com>
Date: Fri, 05 Jun 2009 09:03:37 +0300
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
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com>
In-Reply-To: <20090605052755.GE11755@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> I think so.  Given guarantees G1..Gn (0 <= Gi <= 1; sum(Gi) <= 1), and a  
>> cpu hog running in each group, how would the algorithm divide resources?
>>
>>     
>
> As per the matrix calculation, but as soon as we reach an idle point,
> we redistribute the b/w and start a new quantum so to speak, where all
> groups are charged up to their hard limits.
>
> For your question, if there is a CPU hog running, it would be as per
> the matrix calculation, since the system has no idle point during the
> bandwidth period.
>   

So the groups with guarantees get a priority boost.  That's not a good 
side effect.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

