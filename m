Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXIKQua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXIKQua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXIKQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:49:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:32884 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXIKQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:49:54 -0400
Date: Tue, 11 Sep 2007 18:50:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andreas Steffan <a.steffan@deas-online.de>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Suspend corrupts bios clock since 2.6.21
Message-ID: <20070911165027.GB26206@elf.ucw.cz>
References: <fa.Hms7k1HwOwCbv7cPqUWGLhT5uyk@ifi.uio.no> <46D1D6D1.5040203@shaw.ca> <200708270045.09050.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708270045.09050.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-08-27 00:45:08, Rafael J. Wysocki wrote:
> On Sunday, 26 August 2007 21:38, Robert Hancock wrote:
> > Andreas Steffan wrote:
> > > Hallo everybody,
> > > 
> > > I am running fedora core 7 on my Dell latitude D810 notebook (BIOS
> > > rev A05).
> > > 
> > > Since 2.6.21 I found that suspending (to disk and to ram) corrupts
> > > the bios clock most of the time (not always). The corruption is
> > > happening during suspend. When I enter the system bios right after
> > > I switch the system back on, I find the bios clock is set to a time
> > > far in the future (many years). I guess that problem is related to
> > > the clock changes that where introduced with 2.6.21.
> > > 
> > > Please let me know if you want me to provide further information to
> > > get this problem fixed.
> > > 
> > > If there is a known quirk to work around this problem, I would
> > > really appreciate a hint.
> > > 
> > > PS: I have not yet tried 2.6.22.4-65.fc7, but the latest 2.6.22 kernel
> > > before showed the same behaviour for me.
> > 
> > Please check if PM_TRACE is enabled in your kernel configuration. It 
> > will do this intentionally.
> 
> Yes, but only if you have "1" in /sys/power/pm_trace ...

Maybe we should add printk somewhere like "pm_trace used -> I
corrupted CMOS clock for you, don't complain"... :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
