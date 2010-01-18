Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111Ab0ARNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0ARNwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385Ab0ARNwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:52:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63749 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0ARNwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nf62k1C4kFFnuYvruD/WI7/6NlvNsOYMFtwshax0wzgj13CfwbzhTEzT0eEhg4OWeu
         p3ERMa+PzOZ1Dzcp4ft4PJKo9MkfhNNvCA9KSWHRHguDfME7vQr4/H7c38Dr4RnI2YS5
         WCBzP3LQ4K+qN7yFc/0Rlyj07PWBEBl0icsiU=
Date: Mon, 18 Jan 2010 14:52:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [GIT PULL] perf scheduling updates: flexible/pinned groups
	reordering, optimizations
Message-ID: <20100118135204.GC10364@nowhere>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com> <1263800285.4283.11.camel@laptop> <20100118075826.GA25476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118075826.GA25476@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 08:58:26AM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sun, 2010-01-17 at 13:22 +0100, Frederic Weisbecker wrote:
> > > Ingo,
> > > 
> > > Please pull the perf/scheduling branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	perf/scheduling
> > > 
> > > It brings more progresses wrt scheduling ordering between pinned
> > > and flexible events.
> > > 
> > > There is still some work to do, for example concerning context spinlocks
> > > that could be acquired once instead of multiple times in some areas.
> > > 
> > > But this set is still much more optimized than what we had before,
> > > especially because of the third patch.
> > 
> > Looks very nice, thanks Frederic!
> > 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Pulled, thanks guys!


In case you haven't yet pushed it, I've pushed a
perf/scheduling-2 branch which is exactly the same
than perf/scheduling but with Peter's ack added on these
4 patches.

Thanks.

