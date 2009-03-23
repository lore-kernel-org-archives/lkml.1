Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbZCWOsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbZCWOsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZCWOsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:48:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbZCWOsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:48:25 -0400
Date: Mon, 23 Mar 2009 10:48:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] blktrace: various cleanups and fixes
In-Reply-To: <20090320110921.GA10840@elte.hu>
Message-ID: <alpine.DEB.2.00.0903231047460.3578@gandalf.stny.rr.com>
References: <49C2F599.3060306@cn.fujitsu.com> <20090320102058.GC6256@elte.hu> <20090320110921.GA10840@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Mar 2009, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > While trying to use blktrace in -tip tree, I encounted kernel NULL 
> > > dereference, so I looked into the code, and then found some other 
> > > bugs.
> > > 
> > > This patchset is part 1, and I have some other pending fixes.
> > > 
> > > Each patch is small and straightforward, and should be easy to review:
> > > 
> > > [PATCH 1/7] blktrace: fix possible memory leak
> > > [PATCH 2/7] blktrace: make blk_tracer_enabled a bool flag
> > > [PATCH 3/7] blktrace: remove blk_probe_mutex
> > > [PATCH 4/7] blktrace: don't increase blk_probes_ref if failed to setup blk trace
> > > [PATCH 5/7] blktrace: report EBUSY correctly
> > > [PATCH 6/7] blktrace: remove sysfs_blk_trace_enable_show/store()
> > > [PATCH 7/7] blktrace: avoid accessing NULL bdev->bd_disk
> > > ---
> > >  blktrace.c |  154 +++++++++++++++++--------------------------------------------
> > >  1 file changed, 45 insertions(+), 109 deletions(-)
> > > 
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Nice fixes. Applied to tip:tracing/blktrace, thanks!
> 
> Which would go upstream in the .30 merge window (unless Jens or 
> Steve objects of course).

I didn't see anything wrong with these patches. (sorry for the late reply, 
I'm still going through emails).

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

