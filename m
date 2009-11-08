Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZKHR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZKHR21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZKHR20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:28:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54730 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZKHR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:28:26 -0500
Date: Sun, 8 Nov 2009 18:28:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: Intermittent early panic in try_to_wake_up
Message-ID: <20091108172823.GD1372@ucw.cz>
References: <4AE0EBBD.6090005@gmail.com> <4AF59F24.4010501@gmail.com> <1257611754.4108.12.camel@laptop> <200911072001.16223.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911072001.16223.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > if I copied the entire panic message entirely, including the Code section?
> > > I can try that the next time it happens.
> > 
> > Use vga=ask boot_delay=100 select the highest res possible.
> > 
> > Possibly you could use a digital (video) camera to record the output.
> 
> FWIW, I see a crash in autoremove_wake_function() during resume from suspend
> to RAM that happens immediately before the thawing of tasks.  It always happens
> in the "events" thread.  I can trigger it quite reliably, although not 100% of
> the time.
> 
> I can only see the bottom half of the call trace, so I can't really say what
> kind of a crash this is.

Our oops printing code sucks. It should mdelay after each screen or
something like that. Call trace should be in reverse order, so the
most useful parts stay on the screen...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
