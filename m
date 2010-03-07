Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0CGJhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 04:37:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0CGJhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:37:39 -0500
Message-ID: <4B937363.4070406@redhat.com>
Date: Sun, 07 Mar 2010 11:35:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, ming.m.lin@intel.com,
       sheng.yang@intel.com, Jes Sorensen <Jes.Sorensen@redhat.com>,
       KVM General <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: KVM usability
References: <4B87A6BF.3090301@redhat.com> <20100226111734.GE7463@elte.hu> <4B8813F2.8090208@redhat.com> <20100227105643.GA17425@elte.hu> <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu> <4B8BEFC7.2040000@redhat.com> <20100301174106.GB2362@ghostprotocols.net> <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu> <20100302103045.GA28310@elte.hu>
In-Reply-To: <20100302103045.GA28310@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 12:30 PM, Ingo Molnar wrote:
> * Ingo Molnar<mingo@elte.hu>  wrote:
>
>    
>> Here's our experience with tools/perf/. Hosting the project in the kernel
>> proper helped its quality immensely:
>>
>>   - It's much easier to synchronize new features on the kernel side and on the
>>     user-space side. The two go hand in hand - they are often implemented in
>>     the same patch.
>>      
> Just look at an example from today, a perf+KVM feature patch posted by Yanmin
> Zhang:
>
>    http://www.mail-archive.com/kvm@vger.kernel.org/msg29770.html
>
> That single patch implements the following "perf kvm" commands:
>
>    perf kvm top
>    perf kvm record
>    perf kvm report
>    perf kvm diff
>
> Both the kernel-space and the user-space changes are in that single patch.
>
> Anyone who'd like to try it out can apply it and get an updated kernel plus
> updated tooling and can start profiling KVM guests straight away. You just
> check out the kernel, apply the patch and that's it - you can go. It doesnt
> get any more convenient than that to do development.
>
> Such kind of a unified repository is a powerful concept, and we make use of
> those aspects of tools/perf/ every day. You could only pry it out of our cold,
> dead fingers ;-)
>    

perf really is wonderful, but to be really competitive, and usable to 
more developers, it needs to be in a graphical environment.  I want 
'perf report' output to start out collapsed and drill down by clicking 
on a tree widget.  Clicking on a function name opens its definition.  
'perf annotate' should display annotations on my editor window, not in a 
pager.  I should be able to check events on a list, not using 'perf list'.

Is something like that suitable for tools/perf/?  I think you'll find 
the intersection of kernel developers and GUI developers to be fairly small.

> Btw., this is one of the things that FreeBSD does right - and i believe it is
> one of the technical concepts behind Apple's success as well. Apple, with a
> tenth's of Linux's effective R&D budget can consistently out-develop Linux. I
> think that's in part due to there not being a strict chinese wall between the
> Apple kernel, libraries and applications - it's one coherent project where
> everyone is well-connected to each piece, with no artificial project-cultural
> boundaries and barriers. People can and do move between those areas of the
> larger "Apple" project to achieve their goals - regardless of how many
> components need touching for a given area of interest.
>
> IMHO we should learn from that - while we are good in many areas there's
> always aspects of Linux that can be improved. But i digress.
>    

Folding everything into the kernel tree is one way to approach it; IMO 
it is completely unreasonable.  The kernel is a very small part of a 
complete system.

-- 
error compiling committee.c: too many arguments to function

