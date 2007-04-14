Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXDNJC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXDNJC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 05:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXDNJCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 05:02:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50289 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXDNJCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 05:02:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: Linux 2.6.21-rc6
Date: Sat, 14 Apr 2007 11:05:55 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, pavel@suse.cz, linux-pm@lists.osdl.org
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070413235017.GR5907@stusta.de> <20070414081619.GA24909@melchior.yamamaya.is-a-geek.org>
In-Reply-To: <20070414081619.GA24909@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704141105.56265.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 April 2007 10:16, Tobias Diedrich wrote:
> Adrian Bunk wrote:
> > On Fri, Apr 13, 2007 at 11:29:55PM +0200, Tobias Diedrich wrote:
> > > Linus Torvalds wrote:
> > > 
> > > > We should be getting close to a 2.6.21 release, so please update any 
> > > > regression reports you've done,
> > > 
> > > For me, suspend to disk works only once (has been the case for all
> > > .21-rcs IIRC, but I didn't get around to report it so far).
> > > There are some threads about an issue like this, which is supposed
> > > to be fixed by disabling CONFIG_PCI_MSI, but on my system the
> > > problem persists nonetheless.
> > > 
> > > On the second suspend attempt, the last message I see is
> > > "Suspending console(s)"
> > > 
> > > If I find the time, I'll try to bisect it this weekend.
> > >...
> > 
> > Does the latest -git work?
> 
> Still no luck with
> Linux melchior 2.6.21-rc6-gd791d413-dirty #4 PREEMPT Sat Apr 14 09:34:21 CEST 2007 x86_64 GNU/Linux

Can you boot with init=/bin/bash and see if the problem is present in this
configuration?

Rafael
