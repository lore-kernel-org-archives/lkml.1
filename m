Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbYLLQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbYLLQqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbYLLQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:46:34 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:42339 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbYLLQqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:46:34 -0500
Message-ID: <49429532.7030107@nortel.com>
Date: Fri, 12 Dec 2008 10:45:38 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: eranian@gmail.com, Vince Weaver <vince@deater.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
References: <20081211155230.GA4230@elte.hu>	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>	 <1229070345.12883.12.camel@twins>	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins>
In-Reply-To: <1229073834.12883.41.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 16:45:44.0068 (UTC) FILETIME=[13424C40:01C95C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-12-12 at 09:59 +0100, stephane eranian wrote:

>>Furthermore, Linux commercial distribution release cycles do not
>>align well with new processor
>>releases. I can boot my RHEL5 kernel on a Nehalem system and it would
>>be  nice not to have to
>>wait for a new kernel update to get the full Nehalem PMU event table,
>>so I can program more than
>>the basic 6 architected events of Intel X86.
> 
> 
> Talking with my community hat on, that is an artificial problem created
> by distributions, tell them to fix it.
> 
> All it requires is a new kernel module that describes the new chip,
> surely that can be shipped as easily as a new library.

I have to confess that I haven't had a chance to look at the code.  Is 
the current proposal set up in such a way as to support loading a module 
and having the new description picked up automatically?


>>Changing the
>>kernel is not an option for
>>many end-users, it may even require re-certifications for many customers.

> What we do care about is technical arguments, and last time I checked,
> hardware resource scheduling was an OS level job.

Here I agree.

> But if the PMU control is critical to the enterprise deployment of
> $customer, then he would have to re-certify on the library update too.

It may not have any basis in fact, but in practice it seems like kernel 
changes are considered more risky than userspace changes.

As you say though, it's not likely that most production systems would be 
running performance monitoring code, so this may only be an issue for 
development machines.


Chris
