Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXEKTAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXEKTAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762784AbXEKS7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:59:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3125 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755653AbXEKS7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:59:34 -0400
Date: Fri, 11 May 2007 13:21:16 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070511132116.GH4052@ucw.cz>
References: <20070507140453.GD3868@ucw.cz> <1178550653.11851.191.camel@pmac.infradead.org> <20070507194949.GB3981@ucw.cz> <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com> <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl> <1178646751.2824.48.camel@pmac.infradead.org> <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl> <1178721996.2824.199.camel@pmac.infradead.org> <20070509203335.GA4290@ucw.cz> <1178887402.21820.65.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178887402.21820.65.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > And how about serial terminals?
> > > 
> > > It works fine over serial terminals. Why wouldn't it?
> > 
> > He probably means serial terminals... like physical vt100. I used to
> > have one (vt302 compatible or something).  Most emulators still
> > emulate vt100, and yes, vt100 predates utf-8. 
> 
> I have a serial terminal which can only do lower case (well, actually
> capitals but it's all mapped to lower case since that's more useful).
> 
> When I write code on it, I can't do capital letters. But do I try to
> _force_ you to use only capitals because of my limited terminal?
> 

If I wrote int j, J; in my code, you'd have valid case wanting me to
fix it. And I simply want you to fix useless uses of utf-8. And evil
uses utf8, like int voltage; /* ??V */. I do not know what is so hard
to understand.

You are intentionally making code hard to read. Stop trying to merge
that crap.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
