Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYDBMMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYDBMMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYDBMLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:11:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4358 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753954AbYDBMLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:11:52 -0400
Date: Tue, 1 Apr 2008 21:38:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Didier Raboud <didier@raboud.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org
Subject: Re: 2.6.25-rc7
Message-ID: <20080401193811.GC4251@ucw.cz>
References: <200803311823.36693.didier@raboud.com> <200803311833.19730.rjw@sisk.pl> <200803311903.16011.didier@raboud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803311903.16011.didier@raboud.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > > with hibernation. With this version, the hibernation (suspend on disk) is
> > > sometimes not resuming correctly. The only thing I get is a blinking
> > > cursor at the top-left of the screen. The problem is that it is not
> > > easily reproducible : sometimes it works, sometimes not.
> > >
> > > AFAIK, 2.6.24 is not affected, but 2.6.25-rc6 and -rc7 (at least) are.
> > >
> > > I'm using a Dell Latitude D630. (lspci attached).
> > >
> > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful
> > > hibernate/resume cycles.
> >
> > Could you please check if the problem is still present if you boot with
> > acpi_new_pts_ordering kernel command line argument?
> 
> It did not help. I had to test 4 hibernation/resume cycles to see the resume 
> fail.

Try to unload modules before suspend/reload them after resume?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
