Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbZE1OqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbZE1OqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZE1OqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:46:09 -0400
Received: from www.tglx.de ([62.245.132.106]:47126 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZE1OqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:46:09 -0400
Date: Thu, 28 May 2009 16:45:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nicholas Mc Guire <der.herr@hofr.at>, wuzj@lemote.com
Subject: Re: [PATCH] mips-specific ftrace support
In-Reply-To: <alpine.DEB.2.00.0905280948410.27708@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0905281644210.3397@localhost.localdomain>
References: <73465d64a9a6773936f5eab3735a69f651c13187.1243458732.git.wuzj@lemote.com> <alpine.DEB.2.00.0905280948410.27708@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Steven Rostedt wrote:
> On Thu, 28 May 2009, wuzhangjin@gmail.com wrote:
> Could you possibly break this patch up into porting the tracers one by 
> one. That is:
> 
> First patch: make function tracing work.
> Second patch: make dynamic tracing work.
> Third patch: add Function graph tracing.
> Forth patch: the time stamp updates
> 
> This would make things a lot easier to review, and if one of the changes 
> breaks something, it will be easier to bisect.

> >  include/linux/clocksource.h    |    4 +-
> >  kernel/sched_clock.c           |    2 +-
> >  kernel/trace/ring_buffer.c     |    3 +-
> >  kernel/trace/trace_clock.c     |    2 +-
> >  scripts/Makefile.build         |    1 +
> >  scripts/recordmcount.pl        |   31 +++-

The changes to these generic files need to be separate as well.

Thanks,

	tglx
