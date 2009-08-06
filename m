Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZHFTMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZHFTMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZHFTMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:12:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbZHFTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:12:07 -0400
Date: Thu, 6 Aug 2009 15:12:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL][2.6.31] ring-buffer/tracing: various
 fixes
In-Reply-To: <20090806122230.GB13995@elte.hu>
Message-ID: <alpine.DEB.2.00.0908061511090.2840@gandalf.stny.rr.com>
References: <20090806025206.306150861@goodmis.org> <20090806041127.GE25478@erda.amd.com> <20090806122230.GB13995@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Aug 2009, Ingo Molnar wrote:

> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > On 05.08.09 22:52:06, Steven Rostedt wrote:
> > > 
> > > Ingo,
> > > 
> > > Please pull the latest tip/tracing/urgent tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > tip/tracing/urgent
> > 
> > Steven,
> > 
> > if there is the chance I would like to see this fix in -rc6 too (I 
> > know you wanted to test it):
> > 
> >  193df82 ring-buffer: Fix advance of reader in rb_buffer_peek()
> > 
> > You can cherry-pick from my oprofile/master tree or linux-next. 
> > The bug throws warnings with oprofile under high loads and I 
> > already got bug reports of this.
> 
> i remember having triggered something similar in tests too. I've 
> cherry-picked it on top of Steve's fixes, for -rc6.

Thanks Ingo,

I thought I had this one go out too, but looking at my repo, it's in my 32 
queue for some reason. :-/  I must have added it to the wrong queue.

-- Steve
