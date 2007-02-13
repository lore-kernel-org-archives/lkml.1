Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXBMVhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXBMVhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXBMVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:37:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1179 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076AbXBMVgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:36:49 -0500
Date: Tue, 13 Feb 2007 21:08:39 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Lee Revell <rlrevell@joe-job.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070213210838.GA5731@ucw.cz>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no> <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no> <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no> <45CD24F6.8090107@shaw.ca> <75b66ecd0702091759q4140680atee2e80f7ca26af03@mail.gmail.com> <20070210043514.GA29679@nineveh.rivenstone.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210043514.GA29679@nineveh.rivenstone.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >I would disagree that it's a peripheral issue, it's pretty core these
> > >days, at least for any hardware that you can stuff in a laptop (though a
> > >fair number of desktops get suspended and resumed these days too).
> >
> > Servers are still the most important Linux market, and don't care
> > about suspend/resume.  I would consider implementing suspend./resume
> > for a driver that will only be used in server or HPC class hardware a
> > waste of valuable development resources.
> 
>     Please allow me to be offensively blunt for a moment.
> 
>     So, the situation seems to be:
> 
>     1. The work of the suspend developer who engages the users who put
>        effort into making suspend work on their hardware (bless
>        their addled little heads) often doesn't meet kernel standards,
>        or isn't well enough documented to prove the real *need* for
>        the features and/or hacks that have happened to get actual
>        users' systems sleeping and running again.
> 
>     2. The swsusp maintainer continues in the belief that as long as
>        their are no bug reports in kernel bugzilla or crossing the
>        (relatively obscure) swsusp mailing lists, it has zarro boogs
>        and meanwhile works on the fourth implementation of suspend
>        support in as many years.  It's in CVS on sourceforge.  There's
>        no documentation whatsoever.
....
>     4. "Everybody" knows suspend doesn't work on Linux without a huge
>        amount of tinkering, deep magic, and dead chickens.  Only
>        Gentoo users seem to bother; everyone else waits for Ubuntu
>        12.04 wherein suspend will "just work".  The Gentoo users all
>        use swsusp2, as it contains the hacks to work around:

Suspend just works in suse10.2 (and suse10.1, and suse10.0, ...)...
thanks to work seife did on pm scripts. It
is not my fault if it is broken on your distro.

>     6. Getting proper power-management support in Linux device drivers
>        is not a priority; drivers without any power management support
>        whatsoever should not only be accepted -- they should be merged
>        without comment or complaint.
> 
>    How is working suspend support ever supposed to happen?

If people stopped sending rants and started sending patches... yep,
that would help. I don't have all the notebooks ever produced, sorry.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
