Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbXIDKV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbXIDKV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXIDKVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:21:50 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:48344 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXIDKVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:21:49 -0400
Date: Tue, 4 Sep 2007 11:21:44 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: 2.6.23-rc4-mm1: mips compile error
Message-ID: <20070904102144.GA23736@linux-mips.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070901154441.GJ9260@stusta.de> <20070904052734.GA2991@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070904052734.GA2991@Krystal>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 01:27:34AM -0400, Mathieu Desnoyers wrote:

> >   CC      arch/mips/kernel/asm-offsets.s
> > In file included from include2/asm/processor.h:22,
> >                  from include2/asm/thread_info.h:15,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/thread_info.h:21,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/preempt.h:9,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/spinlock.h:49,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/seqlock.h:29,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/time.h:8,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/timex.h:57,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:52,
> >                  from 
> > /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/mips/kernel/asm-offsets.c:13:
> > include2/asm/system.h:415:39: error: asm-generic/cmpxchg-local.h: No such file or directory
> > make[2]: *** [arch/mips/kernel/asm-offsets.s] Error 1
> > 
> > <--  snip  -->
> > 
> 
> Hello,
> 
> It is because
> "Add cmpxchg64 and cmpxchg64_local to mips" has been added to the
> git-mips.patch, but it depends on 
> "add-cmpxchg-local-to-generic-for-up.patch" which is not merged yet.
> 
> It was an error in my series file.
> add-cmpxchg-local-to-generic-for-up.patch should come before these
> patches:
> 
> i386-cmpxchg64-80386-80486-fallback.patch
> add-cmpxchg64-to-alpha.patch
> add-cmpxchg64-to-mips.patch
> add-cmpxchg64-to-powerpc.patch
> add-cmpxchg64-to-x86_64.patch

I had add-cmpxchg64-to-mips.patch queued myself also but removed it a few
days ago, so next -mm (if it's not out yet?) should be ok again.

  Ralf
