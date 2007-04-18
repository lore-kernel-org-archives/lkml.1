Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXDRAhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXDRAhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXDRAhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:37:20 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:35488
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXDRAhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:37:18 -0400
Date: Tue, 17 Apr 2007 17:36:49 -0700
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418003649.GA7293@gnuppy.monkey.org>
References: <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net> <20070417041420.GF25513@wotan.suse.de> <20070417095140.GB22626@elte.hu> <4624CF3B.6040704@bigpond.net.au> <f2b55d220704171600w2de57cafhc1b2d8d7df67cc6b@mail.gmail.com> <20070417230754.GR2986@holomorphy.com> <f2b55d220704171652s2474744p8c7d797f9264eceb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220704171652s2474744p8c7d797f9264eceb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 04:52:08PM -0700, Michael K. Edwards wrote:
> On 4/17/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> >The ongoing scheduler work is on a much more basic level than these
> >affairs I'm guessing you googled. When the basics work as intended it
> >will be possible to move on to more advanced issues.
... 

Will probably shouldn't have dismissed your points but he probably means
that can't even get at this stuff until fundamental are in place.

> Clock scaling schemes that aren't integral to the scheduler design
> make a bad situation (scheduling embedded loads with shotgun
> heuristics tuned for desktop CPUs) worse, because the opaque
> heuristics are now being applied to distorted data.  Add a "smoothing"
> scheme for the distorted data, and you may find that you have
> introduced an actual control-path instability.  A small fluctuation in
> the data (say, two bursts of interrupt traffic at just the right
> interval) can result in a long-lasting oscillation in some task's
> "dynamic priority" -- and, on a fully loaded CPU, in the time that
> task actually gets.  If anything else depends on how much work this
> task gets done each time around, the oscillation can easily propagate
> throughout the system.  Thrash city.

Hyperthreading issues are quite similar that clock scaling issues.
Con's infrastructures changes to move things in that direction were
rejected, as well as other infrastructure changes, further infuritating
Con to drop development on RSDL and derivatives.

bill

