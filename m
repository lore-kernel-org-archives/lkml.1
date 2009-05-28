Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbZE1Luz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbZE1Luz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZE1Lur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:50:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57421 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZE1Luq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:50:46 -0400
Date: Thu, 28 May 2009 13:50:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090528115041.GB2159@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop> <200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop> <20090509135452.GE10859@elf.ucw.cz> <1243245214.16743.90.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243245214.16743.90.camel@nigel-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-25 19:53:34, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2009-05-09 at 15:54 +0200, Pavel Machek wrote:
> > > This is going to sound arrogant, but please don't take it that way: I
> > > can't see any other way of putting it. I don't *think* my code is
> > > better. It is better. swsusp has essentially stood still since Pavel
> > > first forked the code and got it merged. Yes, you have done some
> > > great
> > 
> > I don't think _I_ forked anything.
> 
> The conversation for May 2002 (around when you got it merged into
> vanilla) is here:
> 
> https://sourceforge.net/mailarchive/forum.php?forum_name=swsusp-devel&max_rows=100&style=flat&viewmonth=200205
> 
> Not sure why Sourceforge wants you to log in to get at it.

Not sure what to search for in 90+ emails.

> > > new features (support for multiple swap partitions & files, for writing
> > > to ordinary files, for mulithreaded I/O etc etc) making it more useful
> > > and more reliable. There are some new features that have been put in
> > > swsusp, but in just about every case (I think there might be an
> > > exception or two), they're things TuxOnIce had for ages before. eg: SMP
> > > support came with cpu hotplugging in 2.6.12 or so. TuxOnIce had SMP
> > > support in 2.4.
> > 
> > You were moving faster because you did not have to move in small
> > incremental steps, and you were allowed to add temporary hacks into
> > the code. Is that surprising? Not to me.
> 
> No, I moved in small incremental steps too - and the odd big rework.

...and sometimes you just added code that would not be acceptable in
the mainline (graphical progress bar), only to fix that in few
years. That allowed you to go faster, and that would not be allowed in
the mainline.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
