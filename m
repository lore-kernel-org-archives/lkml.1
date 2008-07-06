Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYGHNio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYGHNio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbYGHNib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:38:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2474 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753631AbYGHNia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:38:30 -0400
Date: Sun, 6 Jul 2008 21:48:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26-rc7: Negative powertop values
Message-ID: <20080706194845.GA5617@ucw.cz>
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com> <20080621141615.51f7100c@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621141615.51f7100c@linux.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-06-21 14:16:15, Arjan van de Ven wrote:
> On Sat, 21 Jun 2008 21:16:37 +0200
> "Vegard Nossum" <vegard.nossum@gmail.com> wrote:
> 
> > Hi,
> > 
> > I was testing v2.6.26-rc7 by running lmbench and hotplug/-unplugging
> > CPUs and a few other programs at the same time. Powertop was showing a
> > negative number of wakeups/second and average C3 residency was
> > something really insane. Is there anything strange with this schedstat
> > file, or is there another file I should look at that can explain the
> > strange powertop numbers? Or maybe it's just an artifact of powertop
> > and this has nothing to do with the kernel?
> 
> powertop doesn't assume you do cpu hotunplug (and the internal state
> goes wacky if you do).
> 
> [I assume you know that doing a software unplug you burn more power
> than by leaving the cpu idle]

We should really fix that one day...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
