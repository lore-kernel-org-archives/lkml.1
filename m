Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZAUVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZAUVQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAUVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:16:36 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38858 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZAUVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:16:35 -0500
Message-ID: <49779041.6080804@oracle.com>
Date: Wed, 21 Jan 2009 13:14:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu> <497778E3.1020502@oracle.com> <20090121195623.GA31013@elte.hu>
In-Reply-To: <20090121195623.GA31013@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49779046.01B5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> Ingo Molnar wrote:
>>> We are pleased to announce version 6 of our performance counters subsystem 
>>> implementation. The shortlog, diffstat and the combo patch can be found 
>>> below. The combo patch against latest -git (2.6.29-rc2) can be also found 
>>> at:
>>>
>>>    http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch
>>>
>>> It's also available in tip/master at:
>>>  
>>>    http://people.redhat.com/mingo/tip.git/README
>>>  
>>> There are many changes in the v6 release:
>>>
>>>  - PowerPC performance counters support from Paul Mackerras, for POWER6
>>>    and for the PPC970 family.
>>>
>>>  - ioctl API to disable/enable individual counters and groups without
>>>    closing their fd. This can be useful for libraries, ad-hoc 
>>>    instrumentation and PAPI support.
>>>
>>>  - 'pinned' and 'exclusive' counter attributes - for those
>>>    applications that want to influence counter scheduling explicitly.
>>>
>>>  - The 'perfstat' utility (ex 'timec') has been updated:
>>>
>>>       http://people.redhat.com/mingo/perfcounters/perfstat.c
>>>
>>>  - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
>>>    
>>>       http://people.redhat.com/mingo/perfcounters/kerneltop.c
>> BTW, this kerneltop has nothing to do with that other one??
>>
>> 	http://www.xenotime.net/linux/kerneltop/
> 
> heh, didnt know about that one - there's no connection other than the name 
> :-) The project seems somewhat stale but indeed similar in purpose. Can
> rename to kerneltop2 i guess.

Yes, it's stale.  I plan to update it sometime this year.  :)

I don't care if you rename it or not.

-- 
~Randy
