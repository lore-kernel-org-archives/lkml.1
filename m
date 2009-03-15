Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZCOSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZCOSv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZCOSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:51:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbZCOSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:51:46 -0400
Date: Sun, 15 Mar 2009 11:44:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Berg <johannes@sipsolutions.net>
cc: Jeff Chua <jeff.chua.linux@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
In-Reply-To: <1237140665.24621.2.camel@johannes.local>
Message-ID: <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>  <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>  <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>  (sfid-20090315_040645_344726_0E746861) <1237140665.24621.2.camel@johannes.local>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Mar 2009, Johannes Berg wrote:

> On Sun, 2009-03-15 at 11:06 +0800, Jeff Chua wrote:
> 
> > The commit below is causing problem with associating with the hidden AP as well.
> 
> > 71c11fb57b924c160297ccd9e1761db598d00ac2 is first bad commit
> > commit 71c11fb57b924c160297ccd9e1761db598d00ac2
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Tue Oct 28 18:29:48 2008 +0100
> > 
> >     b43/legacy: remove SSID code
> > 
> >     The SSID programmed into the device is used by the ucode only
> >     to reply to probe requests, a functionality we disable anyway
> >     because it doesn't fit with the mac80211/hostapd programming
> >     model. Therefore, it isn't useful to program the SSID into
> >     device.
> 
> That's not believable, sorry. I know exactly what the microcode uses the
> SSID here for, and it never uses it when we're in station mode.

Jeff - can you test the kernels before-and-after this commit (with _no_ 
other changes) and descibe the differences?

Johannes - "not believable" is simply not an argument. If Jeff can show a 
difference, then your disbelief is totally irrelevant, and clearly shows 
that you are basing your beliefs on incorrect assumptions (like some 
specific version of firmware that isn't the whole story).

		Linus
