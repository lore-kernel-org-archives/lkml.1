Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZIJKJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZIJKJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZIJKJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:09:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35541 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZIJKJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:09:43 -0400
Date: Thu, 10 Sep 2009 12:09:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910100945.GG18599@kernel.dk>
References: <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk> <20090910073317.GP18599@kernel.dk> <20090910074902.GA10634@elte.hu> <20090910075357.GT18599@kernel.dk> <20090910100214.GB21314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910100214.GB21314@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > I went to try -tip btw, but it crashes on boot. Here's the 
> > backtrace, typed manually, it's crashing in 
> > queue_work_on+0x28/0x60.
> > 
> > Call Trace:
> >         queue_work
> >         schedule_work
> >         clocksource_mark_unstable
> >         mark_tsc_unstable
> >         check_tsc_sync_source
> >         native_cpu_up
> >         relay_hotcpu_callback
> >         do_forK_idle
> >         _cpu_up
> >         cpu_up
> >         kernel_init
> >         kernel_thread_helper
> 
> hm, that looks like an old bug i fixed days ago via:
> 
>   00a3273: Revert "x86: Make tsc=reliable override boot time stability checks"
> 
> Have you tested tip:master - do you still know which sha1?

It was -tip pulled this morning, 2-3 hours ago. I don't have the sha
anymore, but it was a fresh pull today.

-- 
Jens Axboe

