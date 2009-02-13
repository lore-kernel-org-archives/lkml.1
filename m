Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbZBMLB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbZBMLB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZBMLBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:01:19 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43241 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZBMLBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:01:18 -0500
Message-ID: <499552F6.8070101@in.ibm.com>
Date: Fri, 13 Feb 2009 16:31:10 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chandru@linux.vnet.ibm.com, paulus@samba.org, akpm@linux-foundation.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       "Jon M. Tollefson [imap]" <kniht@us.ibm.com>
Subject: Re: + powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
 added to -mm tree
References: <200812250806.mBP86LPQ018399@imap1.linux-foundation.org> <20090208204725.GA5514@cmpxchg.org>  <1234139464.31963.79.camel@pasglop> <1234288310.30155.27.camel@nimitz> <4991C71E.9060509@in.ibm.com>
In-Reply-To: <4991C71E.9060509@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chandru wrote:
> Dave Hansen wrote:
>> On Mon, 2009-02-09 at 11:31 +1100, Benjamin Herrenschmidt wrote:
>>  
>>  
>>> (BTW. On another note, do you still have pending bug fixes that didn't
>>> got in .29 ?)
>>>     
>>
>> No, I don't think so.  There were some distro fixes but I couldn't
>> reproduce the bugs on mainline.
>>
>> -- Dave
>>
>>   
> Dave,
>
> If I remember,  the first mail that I sent on this subject said
> 2.6.28-rc9 panics. Unless something has changed in the way
> lmb's are added or are reserved, this should be also
> reproducible with the mainline kernel on the machines that
> had exhibited this problem earlier. I will verify your patch
> on these machines again and let you know the results.
>
> Thanks,
> Chandru

This still occurs with 2.6.29.rc4 on one of the machines that had
shown this problem earlier and Dave's patch solves the issue here.

The system comes up with two nodes...

<snip>
NUMA associativity depth for CPU/Memory: 3
Node 0 Memory: 0x0-0x40000000
Node 1 Memory: 0x40000000-0x80000000

I had to increase the crashkernel memory size to beyond 1G and
hence used crashkernel=1280M@32M. This caused the kernel
to hit the bug as with earlier kernels.

-Chandru

