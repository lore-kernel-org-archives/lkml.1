Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXG0SIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXG0SIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXG0SIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:08:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4816 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755120AbXG0SIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:08:34 -0400
Date: Fri, 27 Jul 2007 10:50:34 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070727105034.GB11895@ucw.cz>
References: <1184970779.4012.38.camel@chaos> <200707210740.19227.ak@suse.de> <Pine.LNX.4.58.0707210147340.29129@gandalf.stny.rr.com> <200707210806.12880.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707210806.12880.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This patch was the beginning of the merger, not the end result. It strived
> > for binary identical images. It was to put everything together as a
> > _starting_point_!   The next thing to do after this is to start the
> > merging.
> 
> Well we've been merging what makes sense since several years. So it's not 
> really starting anything that hasn't already occurred.

I believe there's still a lot that can be merged, and I'm responsible
for some of it. Parts of suspend code should be shared, yet they are
in differently named files in differently named directories.

Ok, I guess I should fix it, arch/x86 or not.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
