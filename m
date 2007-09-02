Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbXIBRQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbXIBRQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXIBRQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:16:11 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2389 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbXIBRQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:16:10 -0400
Date: Sun, 2 Sep 2007 19:16:34 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070902152900.GA23642@elte.hu>
Message-ID: <Pine.LNX.4.64.0709021903240.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
 <1188694367.11196.42.camel@dhcp193.mvista.com> <20070902072029.GA24427@elte.hu>
 <Pine.LNX.4.64.0709021655340.1817@scrub.home> <20070902152900.GA23642@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2 Sep 2007, Ingo Molnar wrote:

> so i thought you must be aware of the problem - at least considering how 
> much you've criticised CFS's "complexity" both in your initial review of 
> CFS (which included object size comparisons) and in this patch 
> submission of yours (which did not include object size comparisons
> though).

Ingo as long as you freely mix algorithmic and code complexity we won't 
get very far. I did code size comparisons for your _stable_ code, which 
was merged into Linus' tree. I explicitly said that my patch is only a 
prototype, so I haven't done any cleanups and tuning in this direction 
yet, so making any conclusions based on code size comparisions is quite 
ridiculous at this point.
The whole point of this patch was to demonstrate the algorithmic changes, 
not to demonstrate a final and perfectly tuned scheduler.

> > > so unmodified CFS is 4.6% faster on this box than with Roman's patch 
> > > and it's also more consistent/stable (10 times lower fluctuations).
> > 
> > Was SCHED_DEBUG enabled or disabled for these runs?
> 
> debugging disabled of course. (your patch has a self-validity checking 
> function [verify_queue()] that is called on SCHED_DEBUG=y, it would have 
> been unfair to test your patch with that included.)

I'll look into it next week.

bye, Roman
