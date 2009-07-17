Return-Path: <linux-kernel-owner+w=401wt.eu-S934580AbZGQNG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbZGQNG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934568AbZGQNG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:06:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54475 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561AbZGQNG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:06:58 -0400
Date: Fri, 17 Jul 2009 15:06:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: xterms freezing on 2.6.31-rc2 (was Re: [regression] Re:
	2.6.31-rc2: X stop accepting keystrokes?)
Message-ID: <20090717130649.GA2202@elf.ucw.cz>
References: <20090714092459.GA2010@elf.ucw.cz> <20090715131611.GB2367@elf.ucw.cz> <20090717125946.GA2022@elf.ucw.cz> <alpine.LNX.2.00.0907171501080.11648@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907171501080.11648@wotan.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-17 15:01:47, Jiri Kosina wrote:
> 
> [ adding some CCs ]
> 
> On Fri, 17 Jul 2009, Pavel Machek wrote:
> 
> > On Wed 2009-07-15 15:16:11, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > ...it happened second time now.  In one case, ctrl-alt-backspace
> > > > helped and I got at least console back, in the other case I had to
> > > > reboot using sysrq.
> > > > 
> > > > ...hmm. It was probably same crash, because console switching has
> > > > probably been locked by X, and I have just one console. I ended up on
> > > > empty console before.
> > > 
> > > It happened four times now. It seems to happen when I type heavily. I
> > > was once able to reproduce it by hitting keys heavily/randomly.
> > 
> > Two more crashes today :-(. -rc2 is pretty much unusable.
> > 
> > ...and they seem to be slightly different crashes. Once keyboard was
> > dead but mouse worked, second time keyboard still worked but xterms
> > kept locking up. I managed to type dmesg into one of them, but that
> > xterm hung in middle of dump :-(.
> 
> I guess that both keyboard and mouse are PS/2 connected, right?

Thinkpad internal keyboard/mouse, yes.

> Any possibility to capture serial console output?

I managed to get dmesg via magic sysrq at some point. I got some
softlockup messages and processes seemed to hang.

I'm no  longer sure how much keyboard related it is. It seems to
happen while typing, but ... the system still reacts to keyboard but
xterms hang. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
