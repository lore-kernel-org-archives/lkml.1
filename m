Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXDZVAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXDZVAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbXDZVAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:00:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36453 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752848AbXDZVAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:00:47 -0400
Date: Thu, 26 Apr 2007 23:00:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426210013.GC21695@elf.ucw.cz>
References: <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <20070425235718.66b71f01@the-village.bc.nu> <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org> <20070426012454.3495b5d8@the-village.bc.nu> <alpine.LFD.0.98.0704251808150.9964@woody.linux-foundation.org> <4630B183.1000905@rtr.ca> <alpine.LFD.0.98.0704260903570.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260903570.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > See? Two *totally* different cases. They have *nothing* in common. Not the
> > > call sequence, not the logic, not *anything*.
> > 
> > Except that both methods cannot rely upon hot-pluggable devices
> > still being present on resume/restore.  It is exceptionally common
> > to unplug all USB/firewire cables, mouse, keyboard, docking cables etc..
> > after a machine is in S2R state.
> 
> Right, and that has nothing to do with suspend/resume. You'd better be 
> able to handle unexpected hotplugs _regardless_.

Actually, with suspend/resume it is quite easy to cheat, and just
"unplug" the hardware on suspend, then "plug it back" on resume. That
works very well for devices like keyboards and mice (where you can't
tell if you are talking to the same hw, anyway).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
