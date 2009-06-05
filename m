Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZFEGdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZFEGdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFEGde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:33:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33423 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZFEGdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:33:33 -0400
Date: Fri, 5 Jun 2009 12:02:43 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605063243.GC3872@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <4A28B539.3050001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28B539.3050001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 09:03:37AM +0300, Avi Kivity wrote:
> Balbir Singh wrote:
>>> I think so.  Given guarantees G1..Gn (0 <= Gi <= 1; sum(Gi) <= 1), 
>>> and a  cpu hog running in each group, how would the algorithm divide 
>>> resources?
>>>
>>>     
>>
>> As per the matrix calculation, but as soon as we reach an idle point,
>> we redistribute the b/w and start a new quantum so to speak, where all
>> groups are charged up to their hard limits.
>>
>> For your question, if there is a CPU hog running, it would be as per
>> the matrix calculation, since the system has no idle point during the
>> bandwidth period.
>>   
>
> So the groups with guarantees get a priority boost.  That's not a good  
> side effect.

That happens only in the presence of idle cycles when other groups [with or
without guarantees] have nothing useful to do. So how would that matter
since there is nothing else to run anyway ?

Regards,
Bharata.
