Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbXE0TEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbXE0TEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 15:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbXE0TEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 15:04:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54299 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbXE0TEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 15:04:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Sun, 27 May 2007 21:09:48 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <1180008394.15600.26.camel@localhost> <200705272032.15971.rjw@sisk.pl> <20070527184402.GA21161@srcf.ucam.org>
In-Reply-To: <20070527184402.GA21161@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272109.50378.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 20:44, Matthew Garrett wrote:
> On Sun, May 27, 2007 at 08:32:14PM +0200, Rafael J. Wysocki wrote:
> 
> > In particular, please see this message:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2007-May/012301.html
> 
> Yes, there's also the notifier chain for the hardware. However, very few 
> drivers seem to use that - adb seems to be the only one still in the 
> tree. For everything else, the device tree is used in exactly the same 
> way as on x86. If it's safe on Macs but not on x86, then (as far as I 
> can tell) it looks like it's only by luck.
> 
> Anyway. I've tested the following patch on a dual-core x86. No obvious 
> issues yet, but I'll try to put it through a few hundred cycles.

OK

I'm working on a patch that introduces hibernation/suspend notifiers.  It will
conflict with this one a bit, but OTOH it might be useful here too.

I'll post it in a while in a separate thread.

Greetings,
Rafael
