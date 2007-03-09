Return-Path: <linux-kernel-owner+w=401wt.eu-S1767485AbXCIU0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767485AbXCIU0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767487AbXCIU0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:26:32 -0500
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:34836 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767485AbXCIU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:26:31 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 07:26:15 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <20070309182744.GC10394@waste.org> <200703100715.39354.kernel@kolivas.org>
In-Reply-To: <200703100715.39354.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100726.15517.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 07:15, Con Kolivas wrote:
> On Saturday 10 March 2007 05:27, Matt Mackall wrote:
> > On Fri, Mar 09, 2007 at 07:39:05PM +1100, Con Kolivas wrote:
> > > On Friday 09 March 2007 19:20, Matt Mackall wrote:
> > > > And I've just rebooted with NO_HZ and things are greatly improved. At
> > > > idle, Beryl effects are silky smooth (possibly better than stock) and
> > > > shows less load. Under 'make', Beryl is still responsive as is
> > > > Galeon. No sign of lagging mouse or typing.
> > > >
> > > > Under make -j 5, things are intermittent. Galeon scrolling is
> > > > sometimes still responsive, but Beryl, terminals and mouse still drag
> > > > quite a bit.
> > >
> > > I just replied before you sent this one out I think our messages passed
> > > each other across the ocean somewhere. I don't quite get what
> > > combination of factors you're saying here caused great improvement. Was
> > > it enabling NO_HZ on mainline cpu scheduler or disabling NO_HZ or on
> > > RSDL?
> >
> > Turning on NO_HZ on RSDL greatly improved it. I have not tried NO_HZ
> > on mainline. The first test was with NO_HZ=n, the second was with
> > NO_HZ=y.
>
> How odd. I would have thought that if an interaction was to occur it would
> have been without the new feature. Clearly what you describe without NO_HZ
> is not the expected behaviour with RSDL. I wonder what went wrong. Are you
> on 100HZ on that laptop? While I expect 100HZ should be ok, it might just
> not be... My laptop is about the same performance and works fine with 100HZ
> under load of all sorts BUT I don't have Beryl (which I would have thought
> swayed things in the opposite direction also).

Oh and can you grep dmesg for:
Scheduler bitmap error

If that occurs it's not performing properly. A subtle bug that's busting my 
chops to try and track down.

-- 
-ck
