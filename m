Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXEYF7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXEYF7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXEYF7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:59:15 -0400
Received: from mx2.go2.pl ([193.17.41.42]:40555 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752226AbXEYF7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:59:15 -0400
Date: Fri, 25 May 2007 08:06:09 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smpboot: cachesize comparison fix in smp_tune_scheduling()
Message-ID: <20070525060609.GA985@ff.dom.local>
References: <20070524103322.GA1920@ff.dom.local> <20070524160207.51a478cd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524160207.51a478cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 04:02:07PM -0700, Andrew Morton wrote:
> On Thu, 24 May 2007 12:33:23 +0200
> Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > 
> > smpboot: cachesize comparison fix in smp_tune_scheduling()
> > 
> > boot_cpu_data.x86_cache_size is signed int and can be < 0 too.
...
> Under what conditions can boot_cpu_data.x86_cache_size be negative?
> 
> Have negative values of boot_cpu_data.x86_cache_size been observed in
> practice?

Sorry, but IMHO every observations are only kind of illusions,
and should have no influence on any serious science, including
computer science.

But, from smpboot.c history:

"[PATCH] i386: Clean up smp_tune_scheduling()
Adrian Bunk [Thu, 7 Dec 2006 01:14:19 +0000 (02:14 +0100)]
- remove the write-only local variable "bandwidth"
- don't set "max_cache_size" in the (cachesize < 0) case:
  that's already handled in kernel/sched.c:measure_migration_cost()"

So, it seems such strange phenomenon could've been observed
long time ago...

Thanks,
Jarek P.
