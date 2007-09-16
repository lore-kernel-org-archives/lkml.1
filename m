Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXIPVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXIPVwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXIPVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:52:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52291 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbXIPVwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:52:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI video mode patch review
Date: Mon, 17 Sep 2007 00:04:05 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46E9AD88.7070400@zytor.com> <46ED97D0.1090608@zytor.com> <20070916205922.GI11983@elf.ucw.cz>
In-Reply-To: <20070916205922.GI11983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170004.06095.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 September 2007 22:59, Pavel Machek wrote:
> Hi!
> 
> > > Many thanks for taking care of this!
> > > 
> > > We already have a patch in -mm, s2ram-kill-old-debugging-junk.patch from Pavel
> > > (http://marc.info/?l=linux-mm-commits&m=118737955611331&w=1), that removes the
> > > #ifdefed blocks and it clashes with your first patch a bit.
> > > 
> > > FYI, I have rebased your first patch on top of the Pavel's patch:
> > > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc6/patches/39-acpi-video-mode-fix.patch
> > > 
> > 
> > Thanks Rafael,
> > 
> > However, I need to send something upstream to Linus for this kernel
> > cycle, so I don't want to base it on an -mm patch.  There are two
> > alternatives, obviously: 1. send my patch in now based on the "change as
> > little as necessary to fix the immediate problem" and then rebase
> > Pavel's patch on top of mine, or 2. for me to send both Pavel's patch
> > and the rebased patch upstream.
> > 
> > Personally, I would prefer to avoid strategy 2 at this late stage in the
> > 2.6.23-rc series.
> 
> Agreed we should have the fix in 2.6.23... Actually doing 2 does not
> seem like a big problem, my patch is pretty straight cleanup (and may
> even fix some machines, as we avoid touching video ram)... But
> resolving conflict is not hard, either; I know, I did it :-).

OK, let's take path 1, then.

Greetings,
Rafael
