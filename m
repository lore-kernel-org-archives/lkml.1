Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZCLKtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZCLKtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZCLKtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:49:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56511 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZCLKtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:49:23 -0400
Date: Thu, 12 Mar 2009 06:47:21 -0400
From: Neil Horman <nhorman@redhat.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for
	tip/tracing/ftrace
Message-ID: <20090312104721.GA6005@shamino.rdu.redhat.com>
References: <20090312023720.144716747@goodmis.org> <20090312080758.4a14d5b4@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312080758.4a14d5b4@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 08:07:58AM +0100, Pierre Ossman wrote:
> On Wed, 11 Mar 2009 22:37:20 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > This patch series implements a better memory management by the
> > ring buffer. It only allocates the buffers for the online CPUS, as well
> > as keeps the buffers to a minimum size until they are used.
> > 
> > Please pull the latest tip/tracing/ftrace tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/ftrace
> > 
> > 
> > Steven Rostedt (4):
> >       tracing: keep ring buffer to minimum size till used
> >       tracing: expand the ring buffers when an event is activated
> >       tracing: fix trace_wait to know to wait on all cpus or just one
> >       ring-buffer: only allocate buffers for online cpus
> > 
> 
> How difficult is it to apply this to 2.6.27? Fedora is still on that
> kernel and it would be nice if I could get my memory back on a
> distribution kernel. :)

I'm looking into it currently.  I'll post a test kernel when I have something
for you.
Neil


