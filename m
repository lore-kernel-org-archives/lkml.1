Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0BUBCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 20:02:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5433 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0BUBCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 20:02:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oZiS6TeLy+KsmL7yBzEiLHNkYbuEx898glvagR8F+2E1b0NgXQ/ZUPxQFDd50zjl4
	i0vKc0ND88RlUJdP9Meqg==
Date: Sat, 20 Feb 2010 17:02:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: lkml@think-future.de
cc: linux-kernel@vger.kernel.org
Subject: Re: Documentation/cgroups/cpusets.txt author: Undelivered Mail
 Returned to Sender
In-Reply-To: <20100220173449.GB19055@localhost>
Message-ID: <alpine.DEB.2.00.1002201700180.20140@chino.kir.corp.google.com>
References: <20100220173449.GB19055@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, lkml@think-future.de wrote:

>   Hi,
> 
>   The file Documentation/cgroups/cpusets.txt features an authors 
>   email address that seems outdated: Paul Jackson <pj@sgi.com>
> 
>   How should an authors email address that's no longer valid be
>   replaced, so next time I'd send in a patch..
> 

commit c222817f6add85197790e0071f6e511eff14ba25
Author: Paul Jackson <pj@sgi.com>
Date:   Fri Oct 3 15:23:42 2008 -0700

    cpusets: remove pj from cpuset maintainers
    
    Remove myself from the kernel MAINTAINERS file for cpusets.  I am leaving
    SGI and probably will not be active in Linux kernel work.  I can be
    reached at <pj@usa.net>.  Contact Derek Fults <dfults@sgi.com> for future
    SGI+cpuset related issues.  I'm off to the next chapter of this good life.
    
    Signed-off-by: Paul Jackson <pj@sgi.com>
    Cc: Paul Menage <menage@google.com>
    Cc: Derek Fults <dfults@sgi.com>
    Cc: John Hesterberg <jh@sgi.com>
    Cc: Paul Jackson <pj@usa.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

scripts/get_maintainer.pl is a good pointer to who to cc on your patches:

	$ ./scripts/get_maintainer.pl -f kernel/cpuset.c
	Paul Menage <menage@google.com>
	Andrew Morton <akpm@linux-foundation.org>
	Li Zefan <lizf@cn.fujitsu.com>
	Ingo Molnar <mingo@elte.hu>
	Miao Xie <miaox@cn.fujitsu.com>
	linux-kernel@vger.kernel.org
