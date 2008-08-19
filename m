Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYHSSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYHSSZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYHSSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:25:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbYHSSZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:25:16 -0400
Date: Tue, 19 Aug 2008 11:22:23 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Justin Madru <jdm64@gawab.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Re: Backport hr-tick fix into .25/.26
Message-ID: <20080819182222.GA25576@suse.de>
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu> <1219127296.10800.357.camel@twins> <20080819092543.GD28713@elte.hu> <1219138380.10800.376.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219138380.10800.376.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:33:00AM +0200, Peter Zijlstra wrote:
> On Tue, 2008-08-19 at 11:25 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Tue, 2008-08-19 at 02:31 +0200, Ingo Molnar wrote:
> > > > * Justin Madru <jdm64@gawab.com> wrote:
> > > > 
> > > > > This commit introduced the bug.
> > > > > commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> > > > > sched: high-res preemption tick
> > > > 
> > > > > And this one fixed it
> > > > >
> > > > > commit 31656519e132f6612584815f128c83976a9aaaef
> > > > > sched, x86: clean up hrtick implementation
> > > > 
> > > > hm, the backport of 31656519 is a bit intrusive.
> > > > 
> > > > find below is an (untested!) version of it - i havent even build-tested 
> > > > it. Does it work for you? But this is Greg's call really.
> > > > 
> > > 
> > > It largely depends on all the new IPI stuff that went into 27 as well, 
> > > so I'd be surprised if its easily backportable..
> > 
> > ah, i see. How about a simple patch then that disables hrtick [given 
> > that it's now fixed .27 but the fix is too intrusive to backport]? Would 
> > that be too risky for -stable?
> 
> That's just flipping sched_feat(HRTICK) to 0 by default.

That sounds reasonable, I'll take a patch for that for -stable :)

thanks,

greg k-h
