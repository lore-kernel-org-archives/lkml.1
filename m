Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbXF1Ota@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbXF1Ota (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762191AbXF1Osy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:48:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2982 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761433AbXF1Osu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:48:50 -0400
Date: Thu, 28 Jun 2007 14:08:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Christian Leber <christian@leber.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070628140815.GA5339@ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070616194634.GA15953@core> <20070624204629.GA28049@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624204629.GA28049@core>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The results are a bit unclear, I took a 2.6.22-rc4 with beep.
> > Logged into KDE.
> > (hardware: Dell Latitude D810)
> > 
> > S = successfull resume
> > D = had to resume 2 times, that means when pressing the power button the
> > LED goes from blinking to on and after a few seconds it goes back to
> > blinking, but without a beep in between; after pressing the power button
> > a second time resume is successfull
> > F = resume failes, NO beep
> > 
> > -run 1: D D F
> > -run 2: D D D(some X garbadge) F
> > -run 3: S S S S S S F
> > -run 4: S S F
> > -run 5: D F
> 
> I tracked the problem halfway down, with 2.6.20-rc1-ubuntu1 [1] it works
> and with 2.6.20-rc2-ubuntu2 [2] not.
> 
> The diff is here, unfortunately the acpi changes are about 100kb.
> http://debian.christian-leber.de/2.2-3.4.patch
> 
> (the problem is a bit different, it suspends, when trying to resume it
> goes back to suspend and when i try again it's dead)

It may well be different problem :-(. 100KB diff and I'm not an acpi
expert :-(.

I just discovered I have problems with s2ram, too, but it looks like
usermodehelper is responsible.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
