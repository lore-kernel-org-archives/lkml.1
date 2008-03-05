Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYCETbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYCETbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYCETat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:30:49 -0500
Received: from mail.amln.net ([88.203.210.2]:57895 "EHLO neon.bastun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbYCETas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:30:48 -0500
Message-ID: <47CEF634.1070506@amln.net>
Date: Wed, 05 Mar 2008 21:36:20 +0200
From: Xpl++ <xpl@amln.net>
User-Agent: Mozilla Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       menage@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
References: <20080304152341.GB5659@linux.vnet.ibm.com> <47CD83C7.4020206@amln.net> <20080305052631.GA26361@linux.vnet.ibm.com> <47CE8A67.3050109@amln.net> <20080305155310.GA5349@linux.vnet.ibm.com>
In-Reply-To: <20080305155310.GA5349@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval,

Dhaval Giani ??????:
>> Imagine having a shared/joint household savings account with your wife, and 
>> taking money from it without your wife knowing and vice versa .. then at 
>> some point when you thought that you have some $5K to buy the new super 
>> duper laptop you dreamt about your entire life - surprise - no enough 
>> resources :)
>> This is somewhat the equivalent of multiple independent resourse managers 
>> :) It won't end well :)
>> Should they be expected to be adequate in doing their job, they cannot be 
>> independent since they manage a shared resource.
>>
>>     
>
> I don't quite agree with your analogy here. The point here is that each
> resource manager operates in its own area, and has already been assigned
> some resources which it cannot change. Its more like you can take $x at
> the most from the account and your wife $y with x+y<=total money.
>   
Ok .. so imagine that your kid got sick and you need more than $x, while 
you wife does not need any money at that particular moment?
Would you:

a) take a loan (buy more hardware/resources, just because we can), 
despite the fact you already have them in you account, and since we're 
talking about your child it's in the interest of both you and your wife 
(tha family, 'the whole' so to speak) to cure the illness

b) notify your wife there is an emergency and you will need some extra 
money which has to come from her $y quota, take the money, make the kid 
happy, and just continue business as usual? (that is - being smart and 
dynamic in resource allocation)

With the proposed libcg, answer a) seems to be the only option .. and my 
company is not like M$ so I don't have extra resources to waste just 
because I was told resources cannot be managed dynamicaly :)
Why would one need to manage node resources dynamicaly: in our real-life 
production system we have to manage resources dynamicaly, because any 
other solution would require at least twice as much hardware, which will 
also inevitably lead to a necessity to hire more qualified admins, which 
is once again not so wise for small/medium business .. and not to 
mention the extra CO2 caused by the few more dozens of servers :)

Regards,
Peter.
