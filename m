Return-Path: <linux-kernel-owner+w=401wt.eu-S1761728AbYETIBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761728AbYETIBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYETIBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:01:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36173 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYETIBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:01:41 -0400
Date: Tue, 20 May 2008 10:02:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-ID: <20080520080236.GA10856@elf.ucw.cz>
References: <200804281239.51729.david-b@pacbell.net> <200805171514.07619.david-b@pacbell.net> <20080519223933.GA2315@elf.ucw.cz> <200805191826.18516.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805191826.18516.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > What about mkdir gpio-N to export it?
> > > 
> > > Ugh.  That would create way more complication than I want
> > > to see here.  I thought about that early on, and decided
> > > that was Not The Way To Go.
> > 
> > ...but it would be consistent with configfs... and face it... doing
> > echo > file to make a directory is seriously ugly.
> 
> This isn't configfs, and I didn't happen to notice any polite
> way for sysfs users to intercept "mkdir", parse the relevant
> directory name, reject illegal names, and pre-populate the
> just-created directory with relevant contents.
> 
> 
> Were you implying it should go into configfs?  If so, do you
> maybe have an update to the patch I sent a day or so ago?

No, sorry.

I'm not sure if it should go to configfs, or if sysfs should be
improved. But "something" should be done, because we will be stuck
with this interface for a long while.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
