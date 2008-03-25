Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYCYX2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYCYX2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYCYX15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:27:57 -0400
Received: from eazy.amigager.de ([213.239.192.238]:53043 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYCYX14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:27:56 -0400
Date: Wed, 26 Mar 2008 00:13:00 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080325231300.GA10641@thinkpad.home.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080320060550.GA13200@dose.home.local> <20080320032501.f387b3ef.akpm@linux-foundation.org> <20080320105432.GA13404@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320105432.GA13404@dose.home.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 11:54:32 +0100, Tino Keitel wrote:
> On Thu, Mar 20, 2008 at 03:25:01 -0700, Andrew Morton wrote:
> > On Thu, 20 Mar 2008 07:05:50 +0100 Tino Keitel <tino.keitel@gmx.de> wrote:
> > 
> > > Hi folks,
> > > 
> > > whereas I had working suspend with 2.6.25-rc5, I had a hang at resume
> > > with git HEAD from March 19th (something after 2.6.25-rc6). I tried it
> > > again and got another hang, so it seems to be reproducible.
> > 
> > Was 2.6.24 OK?
> 
> Yes, mostly ok (some seldom failures).
> 
> > 
> > > Any hints what commit might have broke suspend? I won't have the time
> > > to start a git bisect or any resume debugging using CONFIG_PM_TRACE_RTC
> > > until next Tuesday.
> > > 
> > > This is a Mac mini Core Duo.
> > 
> > I assume Linus doesn't use his any more ;)
> 
> That's too bad.
> 
> > > Here is the lspci -nn output:
> > 
> > Please try Linus's current tree - quite a few things got reverted today
> > which might have fixed this.
> 
> OK, I'll try it.

I tried HEAD from yesterday, but resume still fails. So it looks like I
need to start a git bisect.

Regards,
Tino
