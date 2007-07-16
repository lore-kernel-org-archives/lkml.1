Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXGPWOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXGPWOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762197AbXGPWN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:13:57 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2889 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761573AbXGPWN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:13:56 -0400
Date: Tue, 17 Jul 2007 00:13:08 +0200 (CEST)
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
In-Reply-To: <20070716211851.GB18661@elte.hu>
Message-ID: <Pine.LNX.4.64.0707162351030.1817@scrub.home>
References: <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu>
 <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu>
 <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org>
 <20070716211851.GB18661@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> and note that even on the old scheduler, nice-0 was "3200% more 
> powerful" than nice +19 (with CONFIG_HZ=300),

How did you get that value? At any HZ the ratio should be around 1:10
(+- rounding error).

> in fact i like it that nice -20 has a slightly bigger punch than it used 
> to have before:

"Slightly bigger"??? You're joking, right?
Especially the user levels are doing something completely different now, 
which may break user expectation. While the user couldn't expect anything 
precise, it's still a big difference whether a process at nice 5 gets 75% 
of the time or only 30%.

bye, Roman
