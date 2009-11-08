Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZKHSnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZKHSnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZKHSnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:43:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45533 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbZKHSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:43:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Intermittent early panic in try_to_wake_up
Date: Sun, 8 Nov 2009 19:44:02 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <4AE0EBBD.6090005@gmail.com> <200911072001.16223.rjw@sisk.pl> <20091108172823.GD1372@ucw.cz>
In-Reply-To: <20091108172823.GD1372@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911081944.02233.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 November 2009, Pavel Machek wrote:
> 
> > > > if I copied the entire panic message entirely, including the Code section?
> > > > I can try that the next time it happens.
> > > 
> > > Use vga=ask boot_delay=100 select the highest res possible.
> > > 
> > > Possibly you could use a digital (video) camera to record the output.
> > 
> > FWIW, I see a crash in autoremove_wake_function() during resume from suspend
> > to RAM that happens immediately before the thawing of tasks.  It always happens
> > in the "events" thread.  I can trigger it quite reliably, although not 100% of
> > the time.
> > 
> > I can only see the bottom half of the call trace, so I can't really say what
> > kind of a crash this is.
> 
> Our oops printing code sucks. It should mdelay after each screen or
> something like that. Call trace should be in reverse order, so the
> most useful parts stay on the screen...

In this particular case it should fit into the screen, but it happens during
a VT switch or something like this.

Unfortunately, this issue turns out to be quite difficult to nail down and only
triggers in specific configurations.

Thanks,
Rafael
