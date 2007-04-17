Return-Path: <linux-kernel-owner+w=401wt.eu-S1030945AbXDQXJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030945AbXDQXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030930AbXDQXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:09:58 -0400
Received: from holomorphy.com ([66.93.40.71]:35301 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030929AbXDQXJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:09:54 -0400
Date: Tue, 17 Apr 2007 16:07:54 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417230754.GR2986@holomorphy.com>
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net> <20070417041420.GF25513@wotan.suse.de> <20070417095140.GB22626@elte.hu> <4624CF3B.6040704@bigpond.net.au> <f2b55d220704171600w2de57cafhc1b2d8d7df67cc6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220704171600w2de57cafhc1b2d8d7df67cc6b@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 04:00:53PM -0700, Michael K. Edwards wrote:
> Works, that is, right up until you add nonlinear interactions with CPU
> speed scaling.  From my perspective as an embedded platform
> integrator, clock/voltage scaling is the elephant in the scheduler's
> living room.  Patch in DPM (now OpPoint?) to scale the clock based on
> what task is being scheduled, and suddenly the dynamic priority
> calculations go wild.  Nip this in the bud by putting an RT priority
> on the relevant threads (which you have to do anyway if you need
> remotely audio-grade latency), and the lock affinity heuristics break,
> so you have to hand-tune all the thread priorities.  Blecch.
[...not terribly enlightening stuff trimmed...]

The ongoing scheduler work is on a much more basic level than these
affairs I'm guessing you googled. When the basics work as intended it
will be possible to move on to more advanced issues.


-- wli
