Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbXDRSOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbXDRSOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXDRSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:14:32 -0400
Received: from squawk.glines.org ([72.36.206.66]:51721 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbXDRSOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:14:32 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 14:14:31 EDT
Date: Wed, 18 Apr 2007 10:48:14 -0700
From: Mark Glines <mark@glines.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Bill Huey <billh@gnuppy.monkey.org>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ck] Re: [Announce] [patch] Modular Scheduler Core and
 Completely Fair Scheduler [CFS]
Message-ID: <20070418104814.2c6fdda7@chirp>
In-Reply-To: <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
References: <20070417060955.GO8915@holomorphy.com>
	<20070417061503.GC1057@wotan.suse.de>
	<20070417062621.GL2986@holomorphy.com>
	<20070417070155.GF1057@wotan.suse.de>
	<20070417213954.GE11166@waste.org>
	<20070418031511.GA18452@wotan.suse.de>
	<20070418043831.GR11115@waste.org>
	<20070418050024.GF18452@wotan.suse.de>
	<20070418055525.GS11115@waste.org>
	<alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	<20070418152355.GU11115@waste.org>
	<alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
Organization: Glines.org
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.10.11; i686-pc-linux-gnu)
X-Useless-Header: yay!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 10:22:59 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So if you have 2 users on a machine running CPU hogs, you should
> *first* try to be fair among users. If one user then runs 5 programs,
> and the other one runs just 1, then the *one* program should get 50%
> of the CPU time (the users fair share), and the five programs should
> get 10% of CPU time each. And if one of them uses two threads, each
> thread should get 5%.

This sounds great, to me.

One minor question: is it even possible to be completely fair on SMP?
For instance, if you have a 2-way SMP box running 3 applications, one of
which has 2 threads, will the threaded app have an advantage here?  (The
current system seems to try to keep each thread on a specific CPU, to
reduce cache thrashing, which means threads and processes alike each
get 50% of the CPU.)

Mark
