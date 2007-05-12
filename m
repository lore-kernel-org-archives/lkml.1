Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXELXVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXELXVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 19:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXELXUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 19:20:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60422 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754752AbXELXUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 19:20:54 -0400
Date: Sun, 13 May 2007 01:20:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070512232051.GC761@elf.ucw.cz>
References: <20070507194949.GB3981@ucw.cz> <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com> <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl> <1178646751.2824.48.camel@pmac.infradead.org> <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl> <1178721996.2824.199.camel@pmac.infradead.org> <20070509203335.GA4290@ucw.cz> <1178887402.21820.65.camel@shinybook.infradead.org> <20070511132116.GH4052@ucw.cz> <20070512211144.GO7984@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070512211144.GO7984@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > And how about serial terminals?
> > > > > 
> > > > > It works fine over serial terminals. Why wouldn't it?
> > > > 
> > > > He probably means serial terminals... like physical vt100. I used to
> > > > have one (vt302 compatible or something).  Most emulators still
> > > > emulate vt100, and yes, vt100 predates utf-8. 
> > > 
> > > I have a serial terminal which can only do lower case (well, actually
> > > capitals but it's all mapped to lower case since that's more useful).
> > > 
> > > When I write code on it, I can't do capital letters. But do I try to
> > > _force_ you to use only capitals because of my limited terminal?
> > 
> > If I wrote int j, J; in my code, you'd have valid case wanting me to
> > fix it. And I simply want you to fix useless uses of utf-8. And evil
> > uses utf8, like int voltage; /* ??V */. I do not know what is so hard
> > to understand.
> > 
> > You are intentionally making code hard to read. Stop trying to merge
> > that crap.
> 
> It was °C, and that's IMHO better readable than some kind of
> "degrees C".

It is more readable for you, and more readable on me while in desktop
X. But on Zaurus and on console I see "???C", and I definitely prefer
"degrees C" to _that_.

And I'm clearly not alone.

> Only using 7bit ASCII might have been a good advice in the last 
> millenium. But in the current millenium, most environments handle UTF-8 
> just fine.

Common denominator should be used. That includes 80 columns.

> And we are only talking about documentation and comments - IOW, things 
> not visible for someone running a kernel. Code (including printk's) must 
> stay 7bit ASCII.

Yes, something that cafe driver breaks... it identifies to userland as
"caf???"... but that's another story.

I'd add that variable names must be 7bit ASCII.

> In the worst case, if you managed to find a not UTF-8 capable 
> environment for viewing the kernel sources, the few characters that are 
> not 7bit ASCII are displayed incorrectly, and you'll have to guess which 
> character someone might place in front of a "C" describing something 
> named wBAT_TEMP (you will likely guess it correctly).

Yes, but it would be better to avoid it.. and guessing is much harder
for ???V case (same driver).

I do not think using comments people can actually _read_ is that much
to ask.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
