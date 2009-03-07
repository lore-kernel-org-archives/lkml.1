Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZCGFy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZCGFy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZCGFyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:54:18 -0500
Received: from kroah.org ([198.145.64.141]:53204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751378AbZCGFyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:54:17 -0500
Date: Fri, 6 Mar 2009 21:54:04 -0800
From: Greg KH <greg@kroah.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Christopher Brannon <cmbrannon@cox.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090307055404.GA549@kroah.com>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net> <20090306175708.GD3099@kroah.com> <3aaafc130903062143g4b7d6afel575781208319454e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3aaafc130903062143g4b7d6afel575781208319454e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 12:43:43AM -0500, J.R. Mauro wrote:
> On Fri, Mar 6, 2009 at 12:57 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Mar 03, 2009 at 09:06:46PM -0600, Christopher Brannon wrote:
> >> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> >> reading or writing text strings to a special file named /dev/time.
> >> I implemented such a facility for Linux.  A read of /dev/time produces
> >> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> >> jiffies since boot, and jiffies per second.  Writing a decimal number to
> >> /dev/time sets the system clock to the given number of epoch seconds.
> >> Anyone who is permitted to write to /dev/time may set the clock.
> >> Granting this privilege becomes as easy as modifying groups and file
> >> permissions.
> >>
> >> Signed-off-by: Christopher Brannon <cmbrannon@cox.net>
> >
> > I'm starting to see a few plan9 specific devices being proposed
> > recently, with one making it into the staging tree recently (the p9auth
> > interface).  Should we just start lumping them all together so to keep
> > them in one place?  drivers/plan9/ ?
> 
> That might be a good idea, assuming it doesn't start up a flamewar.

I don't think if we keep it all in one place, it would.

> The Glendix folks are working hard to get a lot of these device files
> and filesystems implemented and it would be nice to see them have a
> place to feel welcome.
> 
> Would it be very involved to get a little sandbox for these things?

drivers/plan9 looks like a nice place to me, any objections?

thanks,

greg k-h
