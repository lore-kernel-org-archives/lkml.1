Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZAZPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZAZPoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAZPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:44:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54363 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZAZPoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:44:46 -0500
Date: Mon, 26 Jan 2009 16:44:44 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mike Travis <travis@sgi.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090126154444.GA23780@atrey.karlin.mff.cuni.cz>
References: <20090113081316.GA2292@elf.ucw.cz> <200901162306.11853.rjw@sisk.pl> <49711EBC.5050101@sgi.com> <200901170113.09724.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901170113.09724.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > There are three patches from Mike Travis that can help:
> > > http://lkml.org/lkml/2009/1/16/377
> > > 
> > > Thanks,
> > > Rafael
> > 
> > Note that these don't really fix anything, just replaces the current
> > method of using set_cpus_allowed with the work_on_cpu call.  If
> > the laptop worked before the [bad] patch, then it should work again
> > now with this one.
> 
> Thanks for the clarification, I misread the changelogs.
> 
> OK, so we still have a cpufreq vs CPU hotplug problem, it seems.  I can't
> reproduce it myself, though.

I kind of lost track here. Is everything fixed, or will there still be
problems in -rc3?

I turned off CPUFREQ to get rid of this problem, so yes, I can
reproduce it easily.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
