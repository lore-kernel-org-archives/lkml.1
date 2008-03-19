Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYCSXa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYCSXa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934501AbYCSWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:01:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57656 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934494AbYCSWBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:01:40 -0400
Date: Wed, 19 Mar 2008 23:02:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend slow in 2.6.25-rc6 (was Re: Suspend and hibernation
	patchset against -rc6)
Message-ID: <20080319220210.GG1811@elf.ucw.cz>
References: <200803172317.33745.rjw@sisk.pl> <200803192243.14520.rjw@sisk.pl> <20080319215729.GF1811@elf.ucw.cz> <200803192259.00091.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803192259.00091.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-19 22:58:59, Rafael J. Wysocki wrote:
> On Wednesday, 19 of March 2008, Pavel Machek wrote:
> > 
> > > > >> Revert ec.c to 2.6.25-rc5 state:
> > > > >>
> > > > >> * this fixes backlight after closing/reopening the lid while in X on
> > > > >> thinkpad x60
> > > > >>
> > > > >> * unfortunately it breaks fn-home/end keyboard brightness control
> > > > > It should also break volume up/down/mute keys. Essentially all the keys on Thinkpad.
> > > > > And it would also be regression to 2.6.24 level.
> > > > 
> > > > As I explained above.
> > > > 
> > > > Unfortunately, applying this means I loose screen as soon as I
> > > > close/reopen lid. 2.6.24 did not behave like that. And it makes my
> > > > machine mostly unusable -- as soon as you try to carry it away, you
> > > > loose video. BAD.
> > > 
> > > Can you text the current -git (preferably without anything on top) pretty please?
> > 
> > Did anything relevant change in the last 8 hours or so?
> 
> No, it didn't.
> 
> > My scripts tell me there's nothing to pull:
> > 
> > Done counting 441 objects.
> > Result has 304 objects.
> > Deltifying 304 objects.
> >  100% (304/304) done
> > Total 304, written 304 (delta 236), reused 121 (delta 75)
> > Fetching pack (head and objects)...
> > Fetching tags...
> > Up to date.
> > 
> > Applying changes...
> > Branch already fully merged.
> > pavel@amd:~$
> 
> Still, the current -git has the offending patch reverted and you're seeing a
> regression nevertheless.
> 
> Is that correct?

Yes.

(Or more precisely, there are two regressions:

* s2ram 5 seconds slower -- fixed by current git

* backlight goes out in X -- not fixed by current git)

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
