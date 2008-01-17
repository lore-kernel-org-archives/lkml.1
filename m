Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbYAQXcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbYAQXcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYAQXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:32:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:34029 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbYAQXcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:32:06 -0500
Message-ID: <478FE465.5000606@windriver.com>
Date: Thu, 17 Jan 2008 17:27:33 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] kgdb:unify x86-kgdb
References: <478F66F6.40107@siemens.com> <478F67BF.4090409@windriver.com> <478F6983.5010707@siemens.com>
In-Reply-To: <478F6983.5010707@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2008 23:27:33.0560 (UTC) FILETIME=[89515380:01C85960]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Jason Wessel wrote:
>   
>> Jan Kiszka wrote:
>>     
>>> diff -up arch/x86/kernel/kgdb_32.c arch/x86/kernel/kgdb_64.c
>>>
>>> screamed for unification. Here it is.
>>>
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>>
>>> ---
>>>  arch/x86/kernel/Makefile_32 |    2 
>>>  arch/x86/kernel/Makefile_64 |    2 
>>>  arch/x86/kernel/kgdb.c      |  561 ++++++++++++++++++++++++++++++++++++++++++++
>>>  arch/x86/kernel/kgdb_32.c   |  414 --------------------------------
>>>  arch/x86/kernel/kgdb_64.c   |  495 --------------------------------------
>>>  5 files changed, 563 insertions(+), 911 deletions(-)
>>>   
>>>       
>> FYI this is already done in the head branch for kgdb which is going into
>> the -mm tree.  You will see the new patch set in the 2.6.25-rcX series.
>>
>> There is now a single x86-lite.patch which contains a number of other
>> modifications to the core-lite.patch to make use of
>> probe_kernel_address() and a new function probe_kernel_write().  Also
>> the die hooks for the "no context" memory faults were removed.
>>     
>
> Hmm, is this any kind of patch I should have seen in your kernel.org
> git? Which branch?
>   
I'll be posting an update to the -mm tree soon.  Presently, I have been
updating the x86 patch set because the x86 developers provided some
insight as to what needed to change to gain adoption into the mainline
kernel.


See:
http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_x86

Right now the scope is only 8 patches worth.  The other archs will be
patched in when I move the patches forward against the -mm tree.

If you or anyone else would like to help, I'll be happy to forward a
copy of the todo list :-)

Thanks,
Jason.
