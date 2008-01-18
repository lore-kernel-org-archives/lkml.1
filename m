Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbYARJLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbYARJLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYARJK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:10:57 -0500
Received: from gecko.sbs.de ([194.138.37.40]:23494 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYARJKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:10:55 -0500
Message-ID: <47906D12.9090206@siemens.com>
Date: Fri, 18 Jan 2008 10:10:42 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] kgdb:unify x86-kgdb
References: <478F66F6.40107@siemens.com> <478F67BF.4090409@windriver.com> <478F6983.5010707@siemens.com> <478FE465.5000606@windriver.com>
In-Reply-To: <478FE465.5000606@windriver.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Jan Kiszka wrote:
>> Jason Wessel wrote:
>>   
>>> Jan Kiszka wrote:
>>>     
>>>> diff -up arch/x86/kernel/kgdb_32.c arch/x86/kernel/kgdb_64.c
>>>>
>>>> screamed for unification. Here it is.
>>>>
>>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>>>
>>>> ---
>>>>  arch/x86/kernel/Makefile_32 |    2 
>>>>  arch/x86/kernel/Makefile_64 |    2 
>>>>  arch/x86/kernel/kgdb.c      |  561 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/kernel/kgdb_32.c   |  414 --------------------------------
>>>>  arch/x86/kernel/kgdb_64.c   |  495 --------------------------------------
>>>>  5 files changed, 563 insertions(+), 911 deletions(-)
>>>>   
>>>>       
>>> FYI this is already done in the head branch for kgdb which is going into
>>> the -mm tree.  You will see the new patch set in the 2.6.25-rcX series.
>>>
>>> There is now a single x86-lite.patch which contains a number of other
>>> modifications to the core-lite.patch to make use of
>>> probe_kernel_address() and a new function probe_kernel_write().  Also
>>> the die hooks for the "no context" memory faults were removed.
>>>     
>> Hmm, is this any kind of patch I should have seen in your kernel.org
>> git? Which branch?
>>   

Meanwhile I realized that the actual head-of-development was some branch
in the corner of kgdb's cvs on sf.net - I hope this will change in the
future... :->

> I'll be posting an update to the -mm tree soon.  Presently, I have been
> updating the x86 patch set because the x86 developers provided some
> insight as to what needed to change to gain adoption into the mainline
> kernel.
> 
> 
> See:
> http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_x86

Thanks, will pick it up and continue to hammer against it.

> 
> Right now the scope is only 8 patches worth.  The other archs will be
> patched in when I move the patches forward against the -mm tree.
> 
> If you or anyone else would like to help, I'll be happy to forward a
> copy of the todo list :-)

Can't promise anything beyond x86 ATM, because that's the arch our
customer asked for. But I will look around here if someone happens to
twiddle thumbs. ;)

Jan
