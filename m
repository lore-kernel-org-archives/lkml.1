Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZB1N6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZB1N6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZB1N6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:58:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49618 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZB1N6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:58:08 -0500
Date: Fri, 27 Feb 2009 22:05:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Fries <david@fries.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: TSC marked unstable on suspend and resume
Message-ID: <20090227210536.GA1476@ucw.cz>
References: <20090221023943.GA4894@spacedout.fries.net> <200902240023.52166.rjw@sisk.pl> <20090224045803.GB4894@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224045803.GB4894@spacedout.fries.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-02-23 22:58:03, David Fries wrote:
> On Tue, Feb 24, 2009 at 12:23:51AM +0100, Rafael J. Wysocki wrote:
> > On Saturday 21 February 2009, David Fries wrote:
> > > I'm getting TSC marked as unsable on hibernate to disk with
> > > 2.6.29-rc3.  The last kernel I ran 2.6.24.4 ran 300+ days without a
> > > problem and does not loose TSC on hibernate.
> > 
> > Ingo, Andrew, can you please tell us who's the right person to look into this
> > problem?
> 
> I'll be looking into it, I haven't yet started debugging it.  If
> anyone has a theory of operation or what I should be lookking for, I'm
> all ears.  This is an old AMD K6-2 300MHz system.  I don't know if it
> matters or not, but I have NO_HZ enabled, but the timer is still going
> off at 1000 Hz.
> 
> I have to decide if it is worth it to split my swap partition in two
> so I can hibernate both my working kernel, and the test kernel.  It
> would be nice to test a kernel and pick up where I left off.  I expect
> rootfstype=ext2 on the test kernel and it really will keep my
> filesystem read only.

Be very careful there... if you accidentally mount rw or have shared
writable partition between production and test environment, you'll
have problems... 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
