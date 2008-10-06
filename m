Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYJGNIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYJGNIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYJGNGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:06:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36598 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754637AbYJGNGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:54 -0400
Date: Mon, 6 Oct 2008 17:11:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Parag Warudkar <parag.lkml@gmail.com>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: config_experimental was Re: [patch 00/04] RFC: Staging tree
	(drivers/staging)
Message-ID: <20081006151151.GE1380@ucw.cz>
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925052725.GA5739@linux-sh.org> <20080925074923.4845005b.randy.dunlap@oracle.com> <20080925105320.ef70065b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925105320.ef70065b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > How? TAINT_EXPERIMENTAL (I'll stick to that, thanks :) and
> > > > CONFIG_EXPERIMENTAL are no different - neither to users nor to
> > > > developers. Here is why -
> > > > Both try to do the same thing - let people use the drivers on their
> > > > own risk (as if the stable ones are developer's risk - but let's keep
> > > > it aside for the moment) and give developers a chance to keep the code
> > > > in sync with mainline and improve it per user problem reports or
> > > > generally make it better.
> > > > 
> > > Uhm.. not quite. As the one that proposed the flag in the first place,
> > > perhaps it helps to cover the rationale (although Greg seems to have
> > > mostly covered that already).
> > > 
> > > EXPERIMENTAL today is pretty damn meaningless. What it tends to mean in
> > 
> > then it would be better if Greg/someone cleaned up the current tree's
> > problems instead of introducing more CRAP under a different name.
> > Oh well, his mind is already made up and I know how difficult it is to
> > change it.
> 
> I shouldn't have said that last sentence.  I apologize to Greg.
> 
> ISTM that the real problems are (a) it's easier to introduce new staging/crap
> than it is to fix EXPERIMENTAL and (b) no one wants to try to fix EXPERIMENTAL.
> 

I do believe that staging != experimental.

experimental == 'good enough code architecture-wise, needs more
testing, coding style is ok'

staging == 'don't look at this after lunch' (at least parts are bad).

Now... I guess someone could go over supported drivers in enterprise
distro, and remove experimental from all of them in mainline...?
Distros pay some attetion to what code they are willing to support...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
