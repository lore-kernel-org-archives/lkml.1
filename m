Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbXGEWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbXGEWcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbXGEWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:32:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58210 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759169AbXGEWcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:32:03 -0400
Date: Fri, 6 Jul 2007 00:32:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070705223202.GF3881@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707042350.25117.rjw@sisk.pl> <20070704224653.GB2491@elf.ucw.cz> <200707052103.17104.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707052103.17104.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Here's the version that uses just one variable, relative to Nigel's
> > > > patch. Hmm, and it also closes nasty trap for the user in
> > > > acpi_sleep_setup; order of parameters actually mattered there,
> > > > acpi_sleep=s3_bios,s3_mode doing something different from
> > > > acpi_sleep=s3_mode,s3_bios .  It actually works here.
> > > > 
> > > > Will you fold it into  patch28, or should I create a changelog?
> > > 
> > > Hmm, I think we should keep the record straight.  Please add a changelog
> > > if that's not a problem.
> > 
> > (I also added documentation and removed the superfluous beep_flags).
> 
> OK, thanks.
> 
> Added to the patchset as
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/50-Optional-Beeping-During-Resume-From-Suspend-To-Ram-tidy.patch
> 
> I think both patches are -mm-ready, aren't they?

I'd say so.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
