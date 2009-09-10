Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZIJTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZIJTFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZIJTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:05:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36629 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZIJTFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:05:22 -0400
Date: Thu, 10 Sep 2009 21:05:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       Russell King <rmk@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.31] zaurus c3000 aka spitz: fix resume
Message-ID: <20090910190518.GC23356@elf.ucw.cz>
References: <20090909075024.GA1400@ucw.cz> <1252507740.14793.115.camel@desktop> <f17812d70909091740m3ef98e44t18dffc6a2c7c1126@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70909091740m3ef98e44t18dffc6a2c7c1126@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-10 08:40:24, Eric Miao wrote:
> On Wed, Sep 9, 2009 at 10:49 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Wed, 2009-09-09 at 09:50 +0200, Pavel Machek wrote:
> >> Hi, Linus!
> >>
> >> Spitz resume was broken for year or likely two, and it would be very
> >> nice to fix it for 2.6.31 release. One liner is below, and it really
> >> can not harm. It already is in Eric's fix queue, so pulling that for
> >> .31 should work, too.
> >>
> >> Do you think you could take it?
> >
> > One checkpatch error here..
> >
> > ERROR: trailing whitespace
> > #77: FILE: arch/arm/mach-pxa/sharpsl_pm.c:681:
> > +^Iif ((!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_LOCK)) || $
> >
> > total: 1 errors, 0 warnings, 10 lines checked
> >
> 
> This has been fixed in the version I sent to Russell.

Thanks and sorry for the noise. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
