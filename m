Return-Path: <linux-kernel-owner+w=401wt.eu-S935010AbXGYSbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbXGYSbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933319AbXGYSaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:30:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3023 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761669AbXGYSaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:30:12 -0400
Date: Wed, 25 Jul 2007 13:59:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Message-ID: <20070725135935.GC9256@ucw.cz>
References: <46A0210E.6010207@tmr.com> <20070720171729.GA19935@deepthought> <20070720104215.476f4cc1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720104215.476f4cc1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I just found a machine which will resume after suspend to memory, using 
> > > the mainline kernel (no suspend2 patch).
> > > 
> > > On resume I was looking at the uptime output, and it was about six 
> > > minutes, FAR longer than the time since resume. So the topic for 
> > > discussion is, should the uptime be
> > > - time sine the original boot
> > > - total uptime since first boot, not counting the time suspended
> > > - time since resume
> > > - some other time around six minutes
> > > 
> > > Any of the first three could be useful and "right" for some casesm thus 
> > > discussion invited.
> > > 
> >  My ibook has always been able to suspend to RAM.  For a long while,
> > uptime was shown as the time since the last boot.  At some point,
> > maybe about a year ago, this was "corrected" to show time since boot
> > _less_ time suspended.
> > 
> >  To be clear, the ibook suspends when I close the lid and resumes
> > when I open it.  Uptime used to be convenient, because I could work
> > out when I'd last booted.
> 
> man uptime:
> 	uptime - tell how long the system has been running
> 
> I claim that the system is not running when it is suspended,
> so the suspension time should not be included in uptime.

Well. I claim that the system is not running when cpu is in hlt.

...and on some weird machines (openmoko, olpc) they have hardware capable of
suspending most of machine between keypresses. Now, PCs are not there
yet, but sooner or later we will sleep/suspend between keypresses.

It is not worth changing now, but at least runtime suspend should
be accounted as 'running'.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
