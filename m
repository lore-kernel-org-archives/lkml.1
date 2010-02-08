Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0BHS22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:28:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41268 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0BHS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:28:26 -0500
Date: Mon, 8 Feb 2010 19:28:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
Message-ID: <20100208182816.GD1469@ucw.cz>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <20100207102016.GH3416@mail.oracle.com> <alpine.LFD.2.00.1002071029040.3829@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002071029040.3829@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 	When I grab tarballs, I only grab .gz.  Bandwidth isn't a
> > problem (3 minutes versus four on my DSL, I still switch over to another
> > screen and check back).  But .bz2 unpacks very slowly in the
> > environments I'm usually grabbing a tarball for.  I save more time
> > unpacking .gz than I do downloading .bz2.
> 
> Ok, there seems to be a fair number of people who prefer .gz files for 
> whatever reason. 
> 
> So I guess I'll stay with the current setup. It's only (somebody elses) 
> diskspace, after all.
> 
> Another option might be to stop generating the .bz2 files, of
 > course. 

It would be good to keep ketchup working.

> Anybody who cares more about network bandwidth than CPU use (ie people who 
> would seem to prefer bz2) would be better off using git instead, which 
> packs things _way_ better, by virtue of being much more incremental.

Well, yes, but git did really badly on arm/128MB machine when I
tried. What would be *really* nice... could we get -rc-s relative to
each other?

That would help a lot. Of course, git wins when you only produce diffs
against .X release, but... That would be 80% bandwidth saving against
current situation and still cpu-friendly.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
