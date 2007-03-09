Return-Path: <linux-kernel-owner+w=401wt.eu-S1767465AbXCISlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767465AbXCISlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767464AbXCISlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:41:10 -0500
Received: from waste.org ([66.93.16.53]:53899 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767465AbXCISlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:41:05 -0500
Date: Fri, 9 Mar 2007 12:27:45 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309182744.GC10394@waste.org>
References: <20070309053931.GA10459@waste.org> <20070309075358.GA10394@waste.org> <20070309082057.GB10394@waste.org> <200703091939.05535.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703091939.05535.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 07:39:05PM +1100, Con Kolivas wrote:
> On Friday 09 March 2007 19:20, Matt Mackall wrote:
> > And I've just rebooted with NO_HZ and things are greatly improved. At
> > idle, Beryl effects are silky smooth (possibly better than stock) and
> > shows less load. Under 'make', Beryl is still responsive as is Galeon.
> > No sign of lagging mouse or typing.
> >
> > Under make -j 5, things are intermittent. Galeon scrolling is
> > sometimes still responsive, but Beryl, terminals and mouse still drag
> > quite a bit.
> 
> I just replied before you sent this one out I think our messages passed each 
> other across the ocean somewhere. I don't quite get what combination of 
> factors you're saying here caused great improvement. Was it enabling NO_HZ on 
> mainline cpu scheduler or disabling NO_HZ or on RSDL?

Turning on NO_HZ on RSDL greatly improved it. I have not tried NO_HZ
on mainline. The first test was with NO_HZ=n, the second was with
NO_HZ=y.

My baseline test was with mainline NO_HZ=y.

As an aside, we should not name config options NO_* or DISABLE_*
because of the potential for double negation.

-- 
Mathematics is the supreme nostalgia of our time.
