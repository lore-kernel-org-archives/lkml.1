Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZFATuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZFATuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZFATtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:49:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47238 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbZFATty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:49:54 -0400
Message-ID: <4A2430A4.1080908@redhat.com>
Date: Mon, 01 Jun 2009 22:48:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?ISO-8859-1?Q?Christi?= =?ISO-8859-1?Q?an_Borntr=E4ger?= 
	<borntraeger@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: add localversion to avoid confusion and conflicts
References: <1243581494.3212.1.camel@localhost.localdomain> <200905290948.34482.borntraeger@de.ibm.com> <1243586626.4379.15.camel@localhost.localdomain> <20090601192624.GA32428@goodmis.org>
In-Reply-To: <20090601192624.GA32428@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>
>> This patch is only for KVM tree and not for linus tree.
>>
>> Lets assume 100 developers are working on kvm tree and they use kvm tree
>> on 2 PCs. So count becomes 200.
>>
>> Like in my case I have dozen of kernel trees so I keep on swapping
>> config between kernels. And I also need to test config from various
>> users. So this count is countless.
>> I think this is the biggest point for adding localversion in -tip.
>> It seems Ingo is busy in perfcounter stuff otherwise he will explain you
>> more advantages.
>>
>> In the least case, Can you differentiate between 1 and 200 ?
>>
>> So by adding this patch we can save lot of developer's time.
>>     
>
> No this patch wastes a lot of developers time. If we accept it, than any
> patch that is added after it will need to be rebased before going to
> Linus. Unless KVM is made up of a bunch of branches like tip is, this will become
> more of a hassle than a benefit.
>   

kvm.git for-linus branches are rebased anyway, since I fold patches that 
fix or revert other patches.  I also (rarely) delay some patches in my 
tree but submit others that came later.

localversion would show up in linux-next, not sure if that's a problem.  
On the other hand, I'm not sure what it's worth.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

