Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbXGQDZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbXGQDZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 23:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbXGQDZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 23:25:48 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4807 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbXGQDZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 23:25:48 -0400
Date: Tue, 17 Jul 2007 05:20:28 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <Pine.LNX.4.64.0707170047230.1817@scrub.home>
Message-ID: <Pine.LNX.4.64.0707170437110.1818@scrub.home>
References: <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu>
 <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu>
 <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org>
 <20070716211851.GB18661@elte.hu> <Pine.LNX.4.64.0707162351030.1817@scrub.home>
 <20070716222909.GA30906@elte.hu> <Pine.LNX.4.64.0707170047230.1817@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 17 Jul 2007, I wrote:

> Playing around with some other nice levels, confirms the theory that 
> something is a little off, so I'm quite correct at saying that the ratio 
> _should_ be 1:10.

Rechecking everything there was actually a small error in my test program, 
so the ratio should be at 1:20. Sorry about that mistake.
Nice level 19 shows the largest artifacts, as that level only gets a 
single tick, so the ratio is often 1:HZ/10 (except for 1000HZ where it's 
5:100). Nevertheless it's still true that in general nice levels were 
independent of HZ (that's all I wanted to say a couple of mails ago).

Ingo, you can start now gloating, but contrary to you I have no problems 
with admitting mistakes and apologizing for them. The point is just that 
I'm reacting better to factual arguments instead of flames (and I think 
it's not just me), so I'm pretty sure I'm still correct about this:

> OTOH you are the one who is wrong about me (again). :-(

bye, Roman
