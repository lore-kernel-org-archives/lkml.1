Return-Path: <linux-kernel-owner+w=401wt.eu-S1762467AbYD3Uc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467AbYD3Uc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765464AbYD3UcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:32:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:56177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765453AbYD3UcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:32:04 -0400
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org
Message-Id: <B50A5950-3660-4866-A59A-5C2317444875@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080430121239.28492328.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] docbook: fix fatal rapidio yet again (and more to come)
Date: Wed, 30 Apr 2008 15:31:48 -0500
References: <Pine.LNX.4.64.0804292009000.18219@shark.he.net> <20080430113500.dfe21880.akpm@linux-foundation.org> <51A34080-7981-4958-B225-4921FC95B84A@kernel.crashing.org> <20080430121239.28492328.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30, 2008, at 2:12 PM, Andrew Morton wrote:
> On Wed, 30 Apr 2008 14:01:12 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>>
>> On Apr 30, 2008, at 1:35 PM, Andrew Morton wrote:
>>> On Tue, 29 Apr 2008 20:10:55 -0700 (PDT)
>>> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
>>>
>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>> Don't refer to file that no longer exists:
>>>> docproc: linux-2.6.25-git14/arch/powerpc/kernel/rio.c: No such file
>>>> or directory
>>>>
>>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>> ---
>>>> Documentation/DocBook/rapidio.tmpl |    1 -
>>>> 1 file changed, 1 deletion(-)
>>>>
>>>> --- linux-2.6.25-git14.orig/Documentation/DocBook/rapidio.tmpl
>>>> +++ linux-2.6.25-git14/Documentation/DocBook/rapidio.tmpl
>>>> @@ -133,7 +133,6 @@
>>>> !Idrivers/rapidio/rio-sysfs.c
>>>>     </sect1>
>>>>     <sect1 id="PPC32_support"><title>PPC32 support</title>
>>>> -!Iarch/powerpc/kernel/rio.c
>>>> !Earch/powerpc/sysdev/fsl_rio.c
>>>> !Iarch/powerpc/sysdev/fsl_rio.c
>>>>     </sect1>
>>>
>>> grumble.
>>>
>>> This is a subset of rapidio-fix-docbook-references.patch, but I
>>> appear to
>>> be unable to interest anyone in merging/reviewing/accepting/ 
>>> anything-
>>> else
>>> that quite large set of patches.
>>>
>>> Guys, those patches were sent six weeks ago and it now looks like
>>> they will
>>> miss 2.6.26.  This is pretty slack of us.  Help?
>>
>> Odd.  I thought Paul had picked up a docbook RapidIO patch from you  
>> in
>> the latest merge round.
>>
>
> Well it's more than "a" patch.  The six-week-old patch series is:
>
> rapidio-add-memory-mapping-driver-to-rapidio.patch
> rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
> rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
> rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to- 
> space-resources.patch
> rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
> rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
> rapidio-fix-docbook-references.patch
> rapidio-fix-kernel-doc-problems.patch
>
> totalling:
>
> arch/powerpc/sysdev/fsl_rio.c       |   13 +
> include/linux/rio.h                 |   10
> drivers/net/Kconfig                 |   10
> drivers/net/rionet.c                |  324 ++++++++++++++++++++++++++ 
> ++++
> drivers/rapidio/Makefile            |    1
> drivers/rapidio/rio.c               |   10
> drivers/rapidio/sallocator/Kconfig  |    9
> drivers/rapidio/sallocator/Makefile |   12 +
> drivers/rapidio/sallocator/bitmap.c |  384 ++++++++++++++++++++++++++ 
> ++++++++++
> include/linux/rio.h                 |   10
> include/linux/rio_drv.h             |   41 +++
> 16 files changed, 1425 insertions(+), 14 deletions(-)
>
>
> (seems that I forgot to cc Jeff on the rionet change too).
>
>
> Oh well.  If nobody puts their hand up in the next 24 hours or so  
> I'll just
> send it all in to Linus.

I'm raising my hand.  The memory map driver needs further review.  If  
the Docbook issues can be applied w/o the other patches I suggest we  
go forward with those.

- k
