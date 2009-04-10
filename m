Return-Path: <linux-kernel-owner+w=401wt.eu-S935555AbZDJLS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555AbZDJLS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763477AbZDJLSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:18:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44211 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbZDJLSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:18:13 -0400
Date: Fri, 10 Apr 2009 13:21:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Regression: First hibernation attempt fails
Message-ID: <20090410112115.GA2513@elf.ucw.cz>
References: <49DDD83F.507@tuffmail.co.uk> <20090410092318.GB30093@elf.ucw.cz> <49DF289D.5070604@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DF289D.5070604@tuffmail.co.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-04-10 12:08:13, Alan Jenkins wrote:
> Pavel Machek wrote:
> > On Thu 2009-04-09 12:13:03, Alan Jenkins wrote:
> >   
> >> Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
> >> wonder if it rings any bells?
> >>
> >> On my laptop (EEE 4G), the first attempt at hibernation fails. 
> >> Subsequent attempts succeed.
> >>
> >> If I use s2disk as normal, I see "snapshotting system", then before it
> >> gets to write out the image, it aborts and switches back to X.   I can't
> >> see any error message, even if I check the log with "dmesg".
> >>
> >> If I use "echo disk > /sys/power/state", echo reports the error "Cannot
> >> allocate memory".
> >>
> >> This only happens if I've logged in to X first.  In fact, I narrowed it
> >> down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
> >> then it doesn't happen.
> >
> > Anything interesting in dmesg?
> 
> Nothing obvious. I've attached my latest at
> <http://bugzilla.kernel.org/show_bug.cgi?id=13058>.

Ok, next theory was that some module stuff is responsible (IIRC, from
the lists). Can you try with everything-built-in (no modules) kernel?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
