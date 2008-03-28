Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYC1XDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYC1XDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYC1XDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:03:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbYC1XDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:03:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core Duo
Date: Sat, 29 Mar 2008 00:03:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <20080320060550.GA13200@dose.home.local> <20080320105432.GA13404@dose.home.local> <20080325231300.GA10641@thinkpad.home.local>
In-Reply-To: <20080325231300.GA10641@thinkpad.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803290003.16199.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of March 2008, Tino Keitel wrote:
> On Thu, Mar 20, 2008 at 11:54:32 +0100, Tino Keitel wrote:
> > On Thu, Mar 20, 2008 at 03:25:01 -0700, Andrew Morton wrote:
> > > On Thu, 20 Mar 2008 07:05:50 +0100 Tino Keitel <tino.keitel@gmx.de> wrote:
> > > 
> > > > Hi folks,
> > > > 
> > > > whereas I had working suspend with 2.6.25-rc5, I had a hang at resume
> > > > with git HEAD from March 19th (something after 2.6.25-rc6). I tried it
> > > > again and got another hang, so it seems to be reproducible.
> > > 
> > > Was 2.6.24 OK?
> > 
> > Yes, mostly ok (some seldom failures).
> > 
> > > 
> > > > Any hints what commit might have broke suspend? I won't have the time
> > > > to start a git bisect or any resume debugging using CONFIG_PM_TRACE_RTC
> > > > until next Tuesday.
> > > > 
> > > > This is a Mac mini Core Duo.
> > > 
> > > I assume Linus doesn't use his any more ;)
> > 
> > That's too bad.
> > 
> > > > Here is the lspci -nn output:
> > > 
> > > Please try Linus's current tree - quite a few things got reverted today
> > > which might have fixed this.
> > 
> > OK, I'll try it.
> 
> I tried HEAD from yesterday, but resume still fails. So it looks like I
> need to start a git bisect.

Can you please try to boot with acpi_new_pts_ordering and retest?

Thanks,
Rafael
