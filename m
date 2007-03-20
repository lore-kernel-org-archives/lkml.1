Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbXCTUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbXCTUJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbXCTUJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:09:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934052AbXCTUJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:09:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc4-mm1
Date: Tue, 20 Mar 2007 21:12:17 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.osdl.org
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320183821.GD2670@elf.ucw.cz> <4600389E.6030901@gmail.com>
In-Reply-To: <4600389E.6030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202112.18236.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 20:40, Jiri Slaby wrote:
> Pavel Machek napsal(a):
> > Hi!
> > 
> >>> Andrew Morton napsal(a):
> >>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> >>> I'm getting this while trying to swsusp:
> >>> Stopping tasks ...
> >>> Stopping kernel threads timed out after 20 seconds (1 tasks refusing to freeze):
> >>>  swapper
> >>>  Restarting tasks ... done.
> >>>
> >>> What to test? Enable PM_DEBUG?
> > 
> > Is it repeatable? Freezer normally works better than that.
> 
> Yes, at least it happened 3 times consecutively, when I tried to asleep the
> machine, then I turned it off.
> 
> >> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
> >> which will simply do a freeze/unfreeze cycle.  Then we can apply various
> >> workloads to the machine while madly stressing the freezer code.  
> > 
> > echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
> > pretty much what you want.
> 
> Ok, I'll try this.

Can I see .config please?

Rafael
