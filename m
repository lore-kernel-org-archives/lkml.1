Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXDQHME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXDQHME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXDQHMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:12:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:41329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXDQHMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:12:01 -0400
Date: Tue, 17 Apr 2007 09:11:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417071126.GG1057@wotan.suse.de>
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:50:03PM -0700, Davide Libenzi wrote:
> On Tue, 17 Apr 2007, Nick Piggin wrote:
> 
> > > All things are not equal; they all have different properties. I like
> > 
> > Exactly. So we have to explore those properties and evaluate performance
> > (in all meanings of the word). That's only logical.
> 
> I had a quick look at Ingo's code yesterday. Ingo is always smart to 
> prepare a main dish (feature) with a nice sider (code cleanup) to Linus ;)
> And even this code does that pretty nicely. The deadline designs looks 
> good, although I think the final "key" calculation code will end up quite 
> different from what it looks now.
> I would suggest to thoroughly test all your alternatives before deciding. 
> Some code and design may look very good and small at the beginning, but 
> when you start patching it to cover all the dark spots, you effectively 
> end up with another thing (in both design and code footprint).
> About O(1), I never thought it was a must (besides a good marketing 
> material), and O(log(N)) *may* be just fine (to be verified, of course).

To be clear, I'm not saying O(logN) itself is a big problem. Type

  plot [10:100] x with lines, log(x) with lines, 1 with lines

into gnuplot. I was just trying to point out that we need to evalute
things. Considering how long we've had this scheduler with its known
deficiencies, let's pick a new one wisely.
