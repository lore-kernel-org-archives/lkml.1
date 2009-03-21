Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZCULa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZCULa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZCULas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:30:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbZCULar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:30:47 -0400
Date: Sat, 21 Mar 2009 04:19:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       utrace-devel@redhat.com, Frank Eigler <fche@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-Id: <20090321041954.72b99e69.akpm@linux-foundation.org>
In-Reply-To: <20090321091235.GA29678@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014244.9ADF1FC3AB@magilla.sf.frob.com>
	<20090321074301.GA19384@elte.hu>
	<20090321013912.ed6039c9.akpm@linux-foundation.org>
	<20090321091235.GA29678@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 10:12:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 21 Mar 2009 08:43:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Roland McGrath <roland@redhat.com> wrote:
> > > 
> > > > From: Frank Ch. Eigler <fche@redhat.com>
> > > > 
> > > > This is v2 of the prototype utrace-ftrace interface.  This code is 
> > > > based on Roland McGrath's utrace API, which provides programmatic 
> > > > hooks to the in-tree tracehook layer.  This new patch interfaces 
> > > > many of those events to ftrace, as configured by a small number of 
> > > > debugfs controls.  Here's the 
> > > > /debugfs/tracing/process_trace_README:
> > > 
> > > Please submit changes/enhancements to kernel/trace/* to the tracing 
> > > tree maintainers (Steve and me) for review, testing and integration.
> > > 
> > > Please also post patches against the latest tracing tree:
> > > 
> > >    http://people.redhat.com/mingo/tip.git/README
> > 
> > uhm, this patch depends on the (large) utrace patch, which is not 
> > kernel/trace material.
> 
> The thing is, utrace crashes in Fedora have dominated kerneloops.org 
> for many months, so i'm not sure what to make of the idea of posting 
> a 4000+ lines of core kernel code patchset on the last day of the 
> development cycle, a posting that has carefully avoided the Cc:-ing 
> of affected maintainers ;-)
> 
> Utrace is very much tracing material - without the ftrace plugin the 
> whole utrace machinery is just something that provides a _ton_ of 
> hooks to something entirely external: SystemTap mainly.

Roland's changelogs don't mention systemtap at all afacit.

That was, umm, major information lossage.

> kernel/utrace.c should probably be introduced as 
> kernel/trace/utrace.c not kernel/utrace.c. It also overlaps pending 
> work in the tracing tree and cooperation would be nice and desired.
> 
> The ftrace/utrace plugin is the only real connection utrace has to 
> the mainline kernel, so proper review by the tracing folks and 
> cooperation with the tracing folks is very much needed for the whole 
> thing.

Actually it seems that the whole utrace-ftrace thing is a big distraction and
could/should just be omitted.  This is a systemtap feature and should be viewed as
such.

This is all a bit weird.
