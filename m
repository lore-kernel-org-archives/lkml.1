Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbXDQH16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbXDQH16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXDQH16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:27:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4729 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXDQH1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:27:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 17 Apr 2007 00:27:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070417070949.GR8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704170021460.30516@alien.or.mcafeemobile.com>
References: <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net>
 <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net>
 <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au>
 <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com>
 <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com>
 <20070417070949.GR8915@holomorphy.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, William Lee Irwin III wrote:

> On Mon, Apr 16, 2007 at 11:50:03PM -0700, Davide Libenzi wrote:
> > I would suggest to thoroughly test all your alternatives before deciding. 
> > Some code and design may look very good and small at the beginning, but 
> > when you start patching it to cover all the dark spots, you effectively 
> > end up with another thing (in both design and code footprint).
> > About O(1), I never thought it was a must (besides a good marketing 
> > material), and O(log(N)) *may* be just fine (to be verified, of course).
> 
> The trouble with thorough testing right now is that no one agrees on
> what the tests should be and a number of the testcases are not in great
> shape. An agreed-upon set of testcases for basic correctness should be
> devised and the implementations of those testcases need to be
> maintainable code and the tests set up for automated testing and
> changing their parameters without recompiling via command-line options.
> 
> Once there's a standard regression test suite for correctness, one
> needs to be devised for performance, including interactive performance.
> The primary difficulty I see along these lines is finding a way to
> automate tests of graphics and input device response performance. Others,
> like how deterministically priorities are respected over progressively
> smaller time intervals and noninteractive workload performance are
> nowhere near as difficult to arrange and in many cases already exist.
> Just reuse SDET, AIM7/AIM9, OAST, contest, interbench, et al.

What I meant was, that the rules (requirements and associated test cases) 
for this new Scheduler Amazing Race should be set forward, and not kept a 
moving target to fit&follow one or the other implementation.


- Davide


