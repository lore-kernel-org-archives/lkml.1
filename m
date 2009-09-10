Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZIJJoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZIJJoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIJJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:44:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54641 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZIJJob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:44:31 -0400
Date: Thu, 10 Sep 2009 11:44:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       srostedt@redhat.com
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910094433.GA18599@kernel.dk>
References: <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk> <20090910070443.GC29009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910070443.GC29009@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Sep 10 2009, Peter Zijlstra wrote:
> > > On Wed, 2009-09-09 at 14:20 +0200, Jens Axboe wrote:
> > > > 
> > > > One thing I also noticed is that when I have logged in, I run xmodmap
> > > > manually to load some keymappings (I always tell myself to add this to
> > > > the log in scripts, but I suspend/resume this laptop for weeks at the
> > > > time and forget before the next boot). With the stock kernel, xmodmap
> > > > will halt X updates and take forever to run. With BFS, it returned
> > > > instantly. As I would expect.
> > > 
> > > Can you provide a little more detail (I'm a xmodmap n00b), how 
> > > does one run xmodmap and maybe provide your xmodmap config?
> > 
> > Will do, let me get the notebook and strace time it on both bfs 
> > and mainline.
> 
> A 'perf stat' comparison would be nice as well - that will show us 
> events strace doesnt show, and shows us the basic scheduler behavior 
> as well.
> 
> A 'full' trace could be done as well via trace-cmd.c (attached), if 
> you enable:
> 
>   CONFIG_CONTEXT_SWITCH_TRACER=y
> 
> and did something like:
> 
>   trace-cmd -s xmodmap ... > trace.txt

trace.txt attached. Steven, you seem to go through a lot of trouble to
find the debugfs path, yet at the very end do:

> 	system("cat /debug/tracing/trace");

which doesn't seem quite right :-)

-- 
Jens Axboe

