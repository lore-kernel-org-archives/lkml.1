Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYIUSik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYIUSik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYIUSic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:38:32 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:55929 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYIUSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:38:30 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+oP+WJYMTcItssr3U7DlsR
Date: Sun, 21 Sep 2008 11:41:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Message-ID: <20080921184058.GC7961@atomide.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <200809200832.15440.david-b@pacbell.net> <20080920161111.GA9873@flint.arm.linux.org.uk> <200809201018.42127.david-b@pacbell.net> <20080920180018.GD9873@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920180018.GD9873@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [080920 11:01]:
> On Sat, Sep 20, 2008 at 10:18:41AM -0700, David Brownell wrote:

<snip snip>

> 
> > > We're into the third day on this one driver.  If every OMAP driver takes
> > > this long ...
> > 
> > That seems like a strange way to account things.  It presumes
> > that the only time review comments should be accepted is within
> > a day of the patch getting posted.  Regardless of whether the
> > reviewer has time at that point.
> 
> You define accounting for things in real time as "strange" - lol.  Your
> following sentences don't follow either.
> 
> My point is that we currently have a BIG problem, and that is the OMAP
> fork being so far out of line with mainline, it isn't funny.  It's
> causing lots of pain for everyone here.  Folk are screaming for mainline
> to be buildable for OMAP.
> 
> There are two approaches to achieve that: take each driver, polish it
> for weeks on end until it's nice and shiney, and then submit it upstream.
> Eventually, given enough man hours, you'll get to the point where you've
> pushed everything upstream, but in the mean time, new work has been
> queued so you need to start at the beginning again.  You've got a job
> for life constantly polishing code.
> 
> The other approach is to decide that we have what we have, and that in
> the interests of efficiently reducing divergence, merging the upstream
> changes with the downstream changes and pushing the result upstream ASAP.
> Once merged, further improvements and cleanups can be made by pushing
> them separately upstream along with any other bug fixes.
> 
> Given the amount of divergence, the only approach which gives realistic
> progress is the second one.
> 
> If you think the first approach is the way to go, then please join in
> with Tony and myself reviewing the _entire_ OMAP tree, polishing every
> patch, and pushing it upstream.  And I mean _everything_.  Not just the
> USB stuff.  Encourage everyone else to do the same - because it will
> take an army of individuals to make any forward progress.

Hey, you gotta give Dave some credit! Dave's been polishing tons of omap
code in addition to the USB, at least I2C, gpio, SPI come to mind. Not to
mention all the blinking leds!

Regarding getting and army of people to fix code, we need to start
following another standard policy: All drivers must have a MAINTAINER
who is capable of fixing things, and ideally doing things the right
way from the start.

It's not going to be enough that few people try to fix stuff and get
burnt out on it over and over again when new omaps come around every
1.5 years.

<snip snip>

Tony
