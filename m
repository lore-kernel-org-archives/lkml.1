Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYFZNFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYFZNFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbYFZMqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:46:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:47632 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778AbYFZMqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:46:31 -0400
Message-ID: <48638E38.5080605@windriver.com>
Date: Thu, 26 Jun 2008 07:40:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Adrian Bunk <bunk@kernel.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
References: <20080622125633.GA8166@damson.getinternet.no>	 <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>	 <200806241136.52430.rusty@rustcorp.com.au>	 <1214294783.25608.75.camel@ymzhang>	 <1214441979.25608.86.camel@ymzhang>	 <20080625191535.e6e60432.akpm@linux-foundation.org> <19f34abd0806260200r40b46012q9bb4ba8783e8d935@mail.gmail.com>
In-Reply-To: <19f34abd0806260200r40b46012q9bb4ba8783e8d935@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 12:40:24.0217 (UTC) FILETIME=[CDBB8890:01C8D789]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Thu, Jun 26, 2008 at 4:15 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>   
>> Could.  But arch/x86/kernel/smpboot.c is an x86-tree file.  I'd expect
>> the x86 maintainers would like a usable changelog and a Tested-by: (if
>> indeed Vegard tested it).
>>     
>
> Hi,
>
> I had the patch (on top of v2.6.26-rc8) in testing for a couple of
> hours now, but like I expected, the APIC error is really hard to
> reproduce. So I fear that we never hit the failure case in the first
> place. On the other hand... I hit a number of (other?) problems:
>
> 1. Spontaneous reboot. This could have been the APIC error thing, I
> have no way to know. I've never seen this before.
> 2. NULL pointer dereference in pick_next_task_fair(). Not new.
> 3. NULL pointer dereference in page_cgroup_zoneinfo. Never seen this
> before (see screenshot #1).
> 4. Page fault in I'm guessing configure_kgdbts() during boot. Never
> seen this before either (screenshot #2).
>   

How often does #4 occur?

Perhaps you can email me directly the .config and kernel boot arguments
you used?  It would be good to determine if the #4 is a victim or
culprit of the crash.  If it is a culprit I would like to try and fix it.

Thanks,
Jason.

