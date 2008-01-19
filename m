Return-Path: <linux-kernel-owner+w=401wt.eu-S1764931AbYASELb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764931AbYASELb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbYASELY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:11:24 -0500
Received: from waste.org ([66.93.16.53]:46312 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687AbYASELX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:11:23 -0500
Subject: Re: PROBLEM: Celeron Core
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chodorenko Michail <misha@one.by>, linux-kernel@vger.kernel.org
In-Reply-To: <20080119011506.GA23798@one.firstfloor.org>
References: <3ed23423adebae08e8f75b6a6a7ce7ff@one.by>
	 <p73prvyalfl.fsf@bingen.suse.de>
	 <1200702477.25782.41.camel@cinder.waste.org>
	 <20080119011506.GA23798@one.firstfloor.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 18 Jan 2008 22:10:42 -0600
Message-Id: <1200715842.25782.95.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 02:15 +0100, Andi Kleen wrote:
> On Fri, Jan 18, 2008 at 06:27:57PM -0600, Matt Mackall wrote:
> > 
> > On Fri, 2008-01-18 at 22:11 +0100, Andi Kleen wrote:
> > > Chodorenko Michail <misha@one.by> writes:
> > > 
> > > > I have a laptop "Extensa 5220", with the processor Celeron based on 'core'
> > > > technology.
> > > > There is ~ / arch/i386/kernel/cpu/cpufreq/p4-clockmod.c in the kernel
> > > > source code
> > > > but there's no line identification of my CPU for apply freqency change
> > > > need to add a ID line 0х16
> > > 
> > > Note that driver will likely do clock throttling on your CPU.
> > > Using that is usually a bad idea because it does not actually
> > > safe power. It's only intended to let the CPU cool down in some situations.
> > 
> > Power consumption is more or less exactly equal to heat production
> > (that's where the power goes, after all!), so either clock throttling
> > DOES save power or it DOES NOT cool the CPU.
> 
> No actually the way it works on modern x86 CPUs is that the best
> strategy for saving power is to do things quickly and then
> idle longer. That means on anything that has reasonably
> deep sleep modi e.g. on older server/desktop systems things might
> be slightly different because they had very little power saving
> features enabled, but it's definitely true for all
> laptop systems from the last several years. But even
> on desktop/server throttling tends to be a bad idea.

Dominik is measuring energy expended (watts * seconds) vs work done (CPU
cycles). But your claim above is "clock throttling...does not save power
[but it lets] the CPU cool down", which talks about power (watts) and
heat (also watts, in fact the *very same* watts) and is physically
impossible. A CPU turns power into heat. Less heat out implies less
power in.

So while throttling may be less efficient in terms of watt seconds used
to compile something than running at full speed, it is incorrect to say
it uses less power. One machine running for an hour throttled to 50%
uses less power (and therefore less battery and cooling) than another
running at full speed for that same hour.

The first machine may take significantly longer to complete its task (or
it may not, if the task is reading email or watching video), but that's
another matter entirely. And whether it's more or less efficient than
other power-saving approaches is also another matter. Throttling does
save power.

-- 
Mathematics is the supreme nostalgia of our time.

