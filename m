Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbXGEWh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbXGEWh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbXGEWhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:37:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55990 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758413AbXGEWhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:37:19 -0400
Date: Fri, 6 Jul 2007 00:37:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070705223716.GG3881@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707050910.21852.nigel@nigel.suspend2.net> <20070704232513.GA2695@elf.ucw.cz> <200707052043.45499.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707052043.45499.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-07-05 20:43:44, Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 01:25, Pavel Machek wrote:
> > 
> > > > > > > Beep_flags should be removed too if you're sticking with /proc.
> > > > > > 
> > > > > > Fixed.
> > > > > 
> > > > > Ta.  But you didn't answer the question - why /proc and not sysfs?
> > > > 
> > > > Do you seriously advocate setting two bits of one variable from /proc,
> > > > and one more bit from /sys?
> > > 
> > > That's partly why I had a separate variable - retaining proc only because it's 
> > > existing functionality, using sysfs for the new code. Remember, too, that 
> > 
> > /proc is not deprecated _that_ much, and notice that this is sysctl,
> > not regular procfs code.
> > 
> > Yes, I see why you did it that way, but I also think you overdisgned
> > it a bit. 
> 
> Hmm, what about adding a second interface to acpi_realmode_flags in sysfs, in
> a separate patch, and scheduling the old one, in /proc, for removal?

Well.. it is sysctl... so we already have separate interface,
sysctl(). Yes, sysctl will probably move to /sys one day, but that is
probably bigger project than just suspend.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
