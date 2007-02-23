Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXBWSbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXBWSbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933173AbXBWSbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:31:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:45480 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933168AbXBWSba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:31:30 -0500
X-Provags-ID: V01U2FsdGVkX19HWiw53zZH3hXrYzxmqCHAG1/2yzIuON1rAHYRnj
	CC5A==
Date: Fri, 23 Feb 2007 19:31:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: David Brownell <david-b@pacbell.net>, linuxppc-dev@ozlabs.org,
       rtc-linux@googlegroups.com, linux-pm@lists.osdl.org,
       Torrance <torrance123@gmail.com>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: rtc suspend()/resume() restores system clock
In-Reply-To: <1172229450.3870.5.camel@johannes.berg>
Message-ID: <Pine.LNX.4.60.0702231927220.8712@poirot.grange>
References: <200702211929.17203.david-b@pacbell.net>  <200702211950.22422.david-b@pacbell.net>
  <Pine.LNX.4.60.0702222352460.6771@poirot.grange> <1172229450.3870.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, sorry for messing up the subject line.

On Fri, 23 Feb 2007, Johannes Berg wrote:

> On Thu, 2007-02-22 at 23:58 +0100, Guennadi Liakhovetski wrote:
> 
> > I think, we only want 1, right? And the latter seems to be more generic / 
> > platform independent? And as a side-effect, powermac would have to migrate 
> > to generic rtc:-)
> 
> Can we migrate all of powerpc to genrtc? But yes, I agree. Had enough to
> do though already to get suspend working :)

Johannes, is there any special meaning in "migrate all of powerpc to 
genrtc"? Or is it just porting every single rtc driver to the generic rtc 
API, moving it under drivers/rtc and adjusting its users or are there any 
global changes required to arch/powerpc? Linkstation is now happily using 
a driver under drivers/rtc, whereas originally it also had a "all special" 
driver, and the migration for me wasn't that difficult... Or is there more 
to do for other platforms?

Thanks
Guennadi
---
Guennadi Liakhovetski
