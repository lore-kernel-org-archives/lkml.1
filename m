Return-Path: <linux-kernel-owner+w=401wt.eu-S1767546AbXCIVXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767546AbXCIVXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767545AbXCIVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:23:50 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1853 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767539AbXCIVXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:23:48 -0500
Date: Fri, 9 Mar 2007 21:23:34 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       jkarlson@cc.hut.fi
Subject: Re: [Bugme-new] [Bug 8100] New: dynticks makes ksoftirqd1 use unreasonable amount of cpu time
Message-ID: <20070309212334.GA6447@ucw.cz>
References: <200702281734.l1SHYAp0021968@fire-2.osdl.org> <20070228140023.46bbba98.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228140023.46bbba98.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8100
> > 
> >            Summary: dynticks makes ksoftirqd1 use unreasonable amount of cpu
> >                     time
> >     Kernel Version: 2.6.21-rc2
> >             Status: NEW
> >           Severity: low
> >              Owner: johnstul@us.ibm.com
> >          Submitter: jkarlson@cc.hut.fi
> > 
> > 
> > Most recent kernel where this bug did *NOT* occur:
> > any kernel without dynticks
> > 
> > Distribution:
> > Debian etch with linux-2.6.21-rc{2,1}
> > 
> > Hardware Environment: 
> > Macbook core2 with bios emulation
> > 
> > Software Environment:
> > The problem is obvious when listening to shoutcast stream with kmplayer and 
> > artsd via wi-fi with  wpa (wpa_supplicant)
> > 
> > Problem Description:
> > ksoftirqd1 uses ~30% cpu-time (by top) no other symptoms, while
> > without dyntikcs cpu-load in similar circumstances is negligible.
> > This might be a dynticks feature rather than bug.

top lies. top has always lied, now it lies more. Do not trust top.
RESOLVED/INVALID?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
