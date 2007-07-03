Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbXGCNTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbXGCNTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXGCNTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:19:45 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:41479 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXGCNTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:19:44 -0400
Date: Tue, 3 Jul 2007 15:21:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070703132102.GS13886@enneenne.com>
References: <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <1183291392.2828.17.camel@shinybook.infradead.org> <20070703094831.GA13413@enneenne.com> <1183468191.29081.17.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183468191.29081.17.camel@shinybook.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 09:09:50AM -0400, David Woodhouse wrote:
> On Tue, 2007-07-03 at 11:48 +0200, Rodolfo Giometti wrote:
> > On Sun, Jul 01, 2007 at 01:03:11PM +0100, David Woodhouse wrote:
> > > 
> > > Seems reasonable enough in principle -- but whatever you do, don't use
> > > "long" for it. That would definitely need different behaviour for 32-bit
> > > vs. 64-bit. Use explicitly sized types such as uint32_t or uint64_t.
> > 
> > Here the patch to convert LinuxPPS data structs into fixed ones.
> > 
> > Please, take a look at it and report possible modifications.
> 
> Looks relatively sane at first glance; busy this week so haven't looked
> very hard yet. Two thing though... you're mixing proper C types
> (uint32_t) and the Linux-specific legacy crap types (__u32). Pick one. I
> won't recommend _which_ one, because if I do I'll make Andrew unhappy.
> But pick one; don't use both at the same time.
> 
> Also read Documentation/volatile-considered-harmful.txt and ponder
> deeply your use of 'volatile' on certain members of struct pps_s.

I will! Thanks a lot.

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
