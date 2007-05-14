Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbXENTRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbXENTRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXENTQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:16:55 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3963 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbXENTQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:16:54 -0400
Date: Mon, 14 May 2007 20:16:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Remove final vestiges of interrupt-related "SA_" flags.
Message-ID: <20070514191638.GD29682@flint.arm.linux.org.uk>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0705141433490.14658@localhost.localdomain> <1179169434.7074.9.camel@chaos> <4648B324.2030801@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648B324.2030801@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:06:12PM -0700, Jeremy Fitzhardinge wrote:
> Thomas Gleixner wrote:
> > On Mon, 2007-05-14 at 14:38 -0400, Robert P. J. Day wrote:
> >   
> >> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> >> index 498ff31..c5d7775 100644
> >> --- a/Documentation/feature-removal-schedule.txt
> >> +++ b/Documentation/feature-removal-schedule.txt
> >> @@ -160,15 +160,6 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
> >>
> >>  ---------------------------
> >>
> >> -What:	Interrupt only SA_* flags
> >> -When:	September 2007
> >> -Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
> >> -	out of the signal namespace.
> >> -
> >> -Who:	Thomas Gleixner <tglx@linutronix.de>
> >> -
> >>     
> >
> > NAK, the removal date is September 2007 so out of tree folks have some
> > time to fix their crap.
> 
> This might be a good example of targeting a specific kernel version
> rather than a date, since anyone who can't fix this immediately with a
> simple search'n'replace is probably trying to support multiple kernels,
> and knowing that "2.6.24" (or whatever) is the cut-off version is more
> useful than "whatever kernel is current in Sept 2007".

Given that it's only just gone in, it's going to take a while for it to
trickle through peoples conciousnesses.  Many people aren't aware of this
change yet - I'm picking people up when I review their patches at the
moment.

September 2007 should, by my estimation, be around the time of the
2.6.23-rc releases, so people have two kernel versions to fix their stuff
up.  That's not unreasonable.

Finally, a date by when people have to have their code updated or it
breaks is more managable from the point of view of planning - you
know when it's potentially going to happen.  You don't know when the
2.6.23 release is going to be, except "sometime in the last half of
this year."

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
