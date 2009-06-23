Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZFWQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZFWQZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZFWQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:25:06 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38078 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbZFWQZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:25:04 -0400
Message-ID: <4A4101D9.9010701@linux.vnet.ibm.com>
Date: Tue, 23 Jun 2009 09:24:57 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: eranian@gmail.com
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.2 - Grouping
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622115017.GC24366@elte.hu> <19008.25905.550815.222975@drongo.ozlabs.ibm.com> <7c86c4470906230036o677e6c48j923a7431b9912372@mail.gmail.com> <19008.37301.779108.964118@cargo.ozlabs.ibm.com> <7c86c4470906230130t69345d91w524d6d13216dc8db@mail.gmail.com>
In-Reply-To: <7c86c4470906230130t69345d91w524d6d13216dc8db@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> On Tue, Jun 23, 2009 at 10:26 AM, Paul Mackerras<paulus@samba.org> wrote:
>> stephane eranian writes:
>>
>>> What happens if I do:
>>>    fd0 = perf_counter_open(&hwc1, getpid(), -1, -1, 0);
>>>    fd1 = perf_counter_open(&hwc2, getpid(), -1, fd0, 0);
>>>
>>> And then:
>>>    fd2 = perf_counter_open(&hwc2, getpid(), -1, fd1, 0);
>> That perf_counter_open call will fail with an EINVAL error because fd1
>> is not a group leader.
>>
> Okay. Thanks.
> 
> But that leads me to another question related to grouping
> which was hinted for by Peter's comment about IBS.
> 
> Can you have multiple sampling events in a group?

There's a PAPI ctest which exercises this - profile_two_events - and it 
does work with the PCL substrate.

- Corey


