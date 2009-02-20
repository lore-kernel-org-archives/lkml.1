Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZBTXEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZBTXEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZBTXEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:04:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50118 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZBTXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:04:45 -0500
Message-ID: <499F3709.2050501@linux.vnet.ibm.com>
Date: Fri, 20 Feb 2009 15:04:41 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu> <499DD4BE.2000704@linux.vnet.ibm.com> <20090220081040.GA11490@elte.hu> <499F30F4.509@linux.vnet.ibm.com> <1235170078.4736.42.camel@laptop>
In-Reply-To: <1235170078.4736.42.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Fri, 2009-02-20 at 14:38 -0800, Corey Ashford wrote:
>> There may be other non-event-related changes that will not be handled 
>> quite as well in this way.  In the original email I hinted at that we 
>> may want an option for mmap'd sample buffers at some point, and so I'm 
>> not clear how you'd provide an ABI to request mmap'd buffers (you would 
>> probably need to be able to request the size and get back a pointer to 
>> the mmap'd buffer).  Would this be done through a special 
>> sys_perf_counter_open call?  Or through a subsequent ioctl call on the 
>> group leader after an open (which requires the counters to be initially 
>> disabled), etc.
> 
> What's stopping a regular mmap() call using the fd obtained from
> sys_perf_counter_open() ?

Perhaps nothing.  I don't know why it didn't occur to me that this could 
be done.  If PCL supports this, great!

Thanks for your reply!

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

