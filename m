Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZGIOrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZGIOrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbZGIOqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:46:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45232 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149AbZGIOqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:46:49 -0400
Date: Thu, 9 Jul 2009 10:45:52 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, rostedt@goodmis.org
Subject: Re: [PATCH 3/2] perf_counters: add debugfs dir option
Message-ID: <20090709144552.GA3102@redhat.com>
References: <cover.1246912068.git.jbaron@redhat.com> <0d7326e18b9860fbf8fb2739f90a23eb9262e24b.1246912068.git.jbaron@redhat.com> <1246955360.8143.113.camel@twins> <20090708201743.GA3123@redhat.com> <20090709004716.GA6275@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709004716.GA6275@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 02:47:17AM +0200, Frederic Weisbecker wrote:
> On Wed, Jul 08, 2009 at 04:17:43PM -0400, Jason Baron wrote:
> > On Tue, Jul 07, 2009 at 10:29:20AM +0200, Peter Zijlstra wrote:
> > > On Mon, 2009-07-06 at 17:12 -0400, Jason Baron wrote:
> > > > Add support to 'perf list' and 'perf stat' for kernel tracepoints. The
> > > > implementation creates a 'for_each_subsystem' and 'for_each_event' for
> > > > easy iteration over the tracepoints. The debugfs filesystem must be mounted
> > > > at '/sys/kernel/debug'. We can add an optional search path in the future.
> > > 
> > > I don't have a single machine that has that mount point.
> > > 
> > > 
> > 
> > ok, The patch below adds support for a 'PERF_DIR_DEBUGFS' environment
> > variable. It also adds a command line for '--debugfs-dir' and
> > '--debugfs-dir='. By default 'perf' continues to look in
> > /sys/kernel/debug, which I believe is most common.
> > 
> > thanks,
> > 
> > -Jason
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> 
> 
> Or why not parsing /etc/mtab ?
> 
> Thanks.
> 
> 
> 

good idea. I'll add that.

thanks,

-Jason
