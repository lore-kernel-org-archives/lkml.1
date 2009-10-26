Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZJZHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZJZHBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZJZHBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:01:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbZJZHBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:01:17 -0400
Date: Mon, 26 Oct 2009 08:01:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
Message-ID: <20091026070112.GA14641@elte.hu>
References: <1256492289.14241.40.camel@marge.simson.net> <20091025123319.2b76bf69@infradead.org> <1256508287.17306.14.camel@marge.simson.net> <1256522035.7356.19.camel@laptop> <1256531907.7117.31.camel@marge.simson.net> <20091025215225.05ac9ac9@infradead.org> <1256533734.7117.45.camel@marge.simson.net> <20091025223657.5ebc2857@infradead.org> <1256536078.7117.67.camel@marge.simson.net> <1256536660.8150.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256536660.8150.3.camel@marge.simson.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Mon, 2009-10-26 at 06:47 +0100, Mike Galbraith wrote:
> > On Sun, 2009-10-25 at 22:36 -0700, Arjan van de Ven wrote:
> 
> > > if you're a multicore domain you better have a shared cache.. 
> > > that's what it should mean. If it does not we should fix that.
> > 
> > Sounds reasonable to me.  I'll go make explosions.
> 
> (Actually, if multicode and sibling does indeed mean shared cache, no 
> arch tinkering should be necessary, just reset SD_WAKE_AFFINE when 
> degenerating should work fine.  Only thing is multicore with 
> siblings.. and test test test)

Correct. There's a few cpus where multicore means separate caches but 
all modern CPUs have shared caches for cores so we want to tune for 
that.

	Ingo
