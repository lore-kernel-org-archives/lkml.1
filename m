Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYGML5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYGML5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYGML5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:57:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50073 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYGML5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:57:35 -0400
Date: Sun, 13 Jul 2008 13:58:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26-rc7: Negative powertop values
Message-ID: <20080713115818.GA7517@elf.ucw.cz>
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com> <20080621141615.51f7100c@linux.intel.com> <20080706194845.GA5617@ucw.cz> <20080708065251.1d7d681f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708065251.1d7d681f@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-08 06:52:51, Arjan van de Ven wrote:
> On Sun, 6 Jul 2008 21:48:45 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > > 
> > > [I assume you know that doing a software unplug you burn more power
> > > than by leaving the cpu idle]
> > 
> > We should really fix that one day...
> 
> yeah but it's incredibly hard to get right (in the light of the bios
> constantly changing what our allowed C-states are)... and the best case

What can happen there? So BIOS decides C4 may no longer be cool idea
because we have AC power now, but that does not mean C4 stops working,
right?

How is changing allowed C-states list supposed to work, anyway? I
mean, we may be in one of those on other CPU when BIOS decides to
change the list...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
