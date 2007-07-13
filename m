Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbXGMEmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbXGMEmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXGMEl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:41:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbXGMEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:41:56 -0400
Date: Thu, 12 Jul 2007 21:40:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-Id: <20070712214048.703567db.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707130415520.1818@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<p734pkbyuu4.fsf@bingen.suse.de>
	<20070711174252.GA16793@elte.hu>
	<20070711211638.GE18767@one.firstfloor.org>
	<20070711214649.GK14435@v2.random>
	<alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707130415520.1818@scrub.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 04:23:43 +0200 (CEST) Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Wed, 11 Jul 2007, Linus Torvalds wrote:
> 
> > Sure, bugs happen, but code that everybody runs the same generally doesn't 
> > break. So a CPU scheduler doesn't worry me all that much. CPU schedulers 
> > are "easy".
> 
> A little more advance warning wouldn't have hurt though.
> The new scheduler does _a_lot_ of heavy 64 bit calculations without any 
> attempt to scale that down a little...
> One can blame me now for not having it brought up earlier, but discussions 
> with Ingo are not something I'm looking forward to. :(
> 

I brought that up a couple of weeks ago, got handwaved at and gave up.

It still isn't obvious to me that all that arith needs to be 64-bit
on 32-bit machines, or even on 64-bit.  4e9 is a big number.
