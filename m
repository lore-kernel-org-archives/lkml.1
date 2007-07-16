Return-Path: <linux-kernel-owner+w=401wt.eu-S1765740AbXGPODZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765740AbXGPODZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbXGPOBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:01:36 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2707 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbXGPOBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:01:34 -0400
Date: Mon, 16 Jul 2007 16:01:17 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070716134036.GA1533@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161548000.1817@scrub.home>
References: <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
 <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu>
 <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> to sum it up: a nice +19 task (the most commonly used nice level in 
> practice) gets 9.1%, 3.9%, 3.1% of CPU time on the old scheduler, 
> depending on the value of HZ. This is quite inconsistent and illogical.

You're correct that you can find artifacts in the extreme cases, it's 
subjective whether this is a serious problem.
It's nice that these artifacts are gone, but that still doesn't explain 
why this ratio had to be increase that much from around 1:10 to 1:69.

bye, Roman
