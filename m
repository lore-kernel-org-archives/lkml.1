Return-Path: <linux-kernel-owner+w=401wt.eu-S1423455AbXBHWXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423455AbXBHWXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423489AbXBHWXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:23:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37974 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423455AbXBHWXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:23:31 -0500
Date: Thu, 8 Feb 2007 14:19:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] Kconfig:  Remove DEBUG_RWSEMS
Message-Id: <20070208141930.a99f91f2.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702081701530.4820@localhost.localdomain>
References: <Pine.LNX.4.64.0702081701530.4820@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 17:06:12 -0500 (EST) Robert P. J. Day wrote:

> 
>   Remove the final vestiges of the kernel config option DEBUG_RWSEMS,
> since it has no value, at least at the moment.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

no other uses of it.

> ---
> 
>   my apologies for pushing this so high up the food chain, but i want
> to submit another patch that sits *right* next to this one in the
> Kconfig.debug file so i either have to do it in two steps, or submit
> those two changes as a single patch, and i don't like doing that.
> 
>   so if this can go in in short order, well, that would be just ducky.
> if it can't, then just toss it and i'll move on to that second patch.
> 
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 5c26818..356a5ab 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -181,19 +181,11 @@ config DEBUG_MUTEXES
>  	 This feature allows mutex semantics violations to be detected and
>  	 reported.
> 
> -config DEBUG_RWSEMS
> -	bool "RW-sem debugging: basic checks"
> -	depends on DEBUG_KERNEL
> -	help
> -	 This feature allows read-write semaphore semantics violations to
> -	 be detected and reported.
> -
>  config DEBUG_LOCK_ALLOC
>  	bool "Lock debugging: detect incorrect freeing of live locks"
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>  	select DEBUG_SPINLOCK
>  	select DEBUG_MUTEXES
> -	select DEBUG_RWSEMS
>  	select LOCKDEP
>  	help
>  	 This feature will check whether any held lock (spinlock, rwlock,
> @@ -209,7 +201,6 @@ config PROVE_LOCKING
>  	select LOCKDEP
>  	select DEBUG_SPINLOCK
>  	select DEBUG_MUTEXES
> -	select DEBUG_RWSEMS
>  	select DEBUG_LOCK_ALLOC
>  	default n
>  	help
> 
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
