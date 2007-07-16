Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbXGPV0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbXGPV0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759751AbXGPV0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:26:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2981 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610AbXGPV0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:26:30 -0400
Date: Mon, 16 Jul 2007 23:25:59 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Matt Mackall <mpm@selenic.com>
cc: Ingo Molnar <mingo@elte.hu>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070716203117.GC11166@waste.org>
Message-ID: <Pine.LNX.4.64.0707162304330.1817@scrub.home>
References: <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu>
 <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home>
 <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home>
 <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home>
 <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home>
 <20070716203117.GC11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Matt Mackall wrote:

> > It's nice that these artifacts are gone, but that still doesn't explain 
> > why this ratio had to be increase that much from around 1:10 to 1:69.
> 
> More dynamic range is better? If you actually want a task to get 20x
> the CPU time of another, the older scheduler doesn't really allow it.

You can already have that, the complete range level from 19 to -20 was 
about 1:80.
There is also something like too much range, I tried it with top at 19 and 
as soon as something runs at -20 it's practically dead, because it gets 
now only 1/5900 of cpu time.

bye, Roman
