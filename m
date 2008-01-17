Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYAQOn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYAQOn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYAQOnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:43:19 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:18553 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYAQOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:43:18 -0500
Message-ID: <478F6983.5010707@siemens.com>
Date: Thu, 17 Jan 2008 15:43:15 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kgdb:unify x86-kgdb
References: <478F66F6.40107@siemens.com> <478F67BF.4090409@windriver.com>
In-Reply-To: <478F67BF.4090409@windriver.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Jan Kiszka wrote:
>> diff -up arch/x86/kernel/kgdb_32.c arch/x86/kernel/kgdb_64.c
>>
>> screamed for unification. Here it is.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> ---
>>  arch/x86/kernel/Makefile_32 |    2 
>>  arch/x86/kernel/Makefile_64 |    2 
>>  arch/x86/kernel/kgdb.c      |  561 ++++++++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/kgdb_32.c   |  414 --------------------------------
>>  arch/x86/kernel/kgdb_64.c   |  495 --------------------------------------
>>  5 files changed, 563 insertions(+), 911 deletions(-)
>>   
> FYI this is already done in the head branch for kgdb which is going into
> the -mm tree.  You will see the new patch set in the 2.6.25-rcX series.
> 
> There is now a single x86-lite.patch which contains a number of other
> modifications to the core-lite.patch to make use of
> probe_kernel_address() and a new function probe_kernel_write().  Also
> the die hooks for the "no context" memory faults were removed.

Hmm, is this any kind of patch I should have seen in your kernel.org
git? Which branch?

Jan
