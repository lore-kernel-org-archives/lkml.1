Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbXIDF1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbXIDF1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 01:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXIDF1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 01:27:37 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:37603 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbXIDF1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 01:27:36 -0400
Date: Tue, 4 Sep 2007 01:27:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: 2.6.23-rc4-mm1: mips compile error
Message-ID: <20070904052734.GA2991@Krystal>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070901154441.GJ9260@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070901154441.GJ9260@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:22:29 up 36 days,  5:41,  4 users,  load average: 2.22, 1.58, 1.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> >  git-mips.patch
> >...
> >  git trees
> >...
> 
> <--  snip  -->
> 
> ...
>   CC      arch/mips/kernel/asm-offsets.s
> In file included from include2/asm/processor.h:22,
>                  from include2/asm/thread_info.h:15,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/thread_info.h:21,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/preempt.h:9,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/spinlock.h:49,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/seqlock.h:29,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/time.h:8,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/timex.h:57,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:52,
>                  from 
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/mips/kernel/asm-offsets.c:13:
> include2/asm/system.h:415:39: error: asm-generic/cmpxchg-local.h: No such file or directory
> make[2]: *** [arch/mips/kernel/asm-offsets.s] Error 1
> 
> <--  snip  -->
> 

Hello,

It is because
"Add cmpxchg64 and cmpxchg64_local to mips" has been added to the
git-mips.patch, but it depends on 
"add-cmpxchg-local-to-generic-for-up.patch" which is not merged yet.

It was an error in my series file.
add-cmpxchg-local-to-generic-for-up.patch should come before these
patches:

i386-cmpxchg64-80386-80486-fallback.patch
add-cmpxchg64-to-alpha.patch
add-cmpxchg64-to-mips.patch
add-cmpxchg64-to-powerpc.patch
add-cmpxchg64-to-x86_64.patch


Mathieu

> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
