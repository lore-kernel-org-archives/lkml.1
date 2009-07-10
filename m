Return-Path: <linux-kernel-owner+w=401wt.eu-S1751562AbZGJESU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbZGJESU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 00:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZGJESL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 00:18:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42626 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZGJESK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 00:18:10 -0400
Date: Fri, 10 Jul 2009 06:17:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       paulus@samba.org, rostedt@goodmis.org
Subject: Re: [PATCH 3/2] perf_counters: add debugfs dir option
Message-ID: <20090710041758.GC5077@elte.hu>
References: <cover.1246912068.git.jbaron@redhat.com> <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com> <1246955360.8143.113.camel@twins> <20090708201743.GA3123@redhat.com> <20090709004716.GA6275@nowhere> <20090709144552.GA3102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709144552.GA3102@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> On Thu, Jul 09, 2009 at 02:47:17AM +0200, Frederic Weisbecker wrote:
> > On Wed, Jul 08, 2009 at 04:17:43PM -0400, Jason Baron wrote:
> > > On Tue, Jul 07, 2009 at 10:29:20AM +0200, Peter Zijlstra wrote:
> > > > On Mon, 2009-07-06 at 17:12 -0400, Jason Baron wrote:
> > > > > Add support to 'perf list' and 'perf stat' for kernel tracepoints. The
> > > > > implementation creates a 'for_each_subsystem' and 'for_each_event' for
> > > > > easy iteration over the tracepoints. The debugfs filesystem must be mounted
> > > > > at '/sys/kernel/debug'. We can add an optional search path in the future.
> > > > 
> > > > I don't have a single machine that has that mount point.
> > > > 
> > > > 
> > > 
> > > ok, The patch below adds support for a 'PERF_DIR_DEBUGFS' environment
> > > variable. It also adds a command line for '--debugfs-dir' and
> > > '--debugfs-dir='. By default 'perf' continues to look in
> > > /sys/kernel/debug, which I believe is most common.
> > > 
> > > thanks,
> > > 
> > > -Jason
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > 
> > 
> > Or why not parsing /etc/mtab ?
> > 
> > Thanks.
> > 
> > 
> > 
> 
> good idea. I'll add that.

Have you seen:

  Subject: [PATCH 2/2] perf tool: Add a trace point event parser.

from Chris Wilson? It already includes a /proc/mounts parser.

	Ingo
