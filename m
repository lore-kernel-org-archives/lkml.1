Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXFIXDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXFIXDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 19:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXFIXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 19:03:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33831 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753351AbXFIXDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 19:03:25 -0400
Date: Sun, 10 Jun 2007 01:02:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070609230239.GA21229@elf.ucw.cz>
References: <20070417181016.GA10903@one.firstfloor.org> <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org> <20070417225815.000b0fdb@the-village.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei> <4626746A.9010701@novell.com> <20070609210151.GB6663@elf.ucw.cz> <Pine.LNX.4.64.0706091426240.6313@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706091426240.6313@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>>I'm not sure if AppArmor can be made good security for the general case,
> >>>>but it is a model that works in the limited http environment
> >>>>(eg .htaccess) and is something people can play with and hack on and may
> >>>>be possible to configure to be very secure.
> >>>>
> >>>Perhaps -- until your httpd is compromised via a buffer overflow or
> >>>simply misbehaves due to a software or configuration flaw, then the
> >>>assumptions being made about its use of pathnames and their security
> >>>properties are out the window.
> >>>
> >>How is it that you think a buffer overflow in httpd could allow an
> >>attacker to break out of an AppArmor profile? This is exactly what
> >>AppArmor was designed to do, and without specifics, this is just
> >>FUD.
> >
> >No, it is not, I already broke AppArmor once, and it took me less then
> >one hour.
> >
> >Give me machine with root shell, and make app armor permit everything
> >but reading /etc/secret.file. AppArmor is not designed for this, but
> >if you want to claim your solution works, this looks like a nice test.
> >
> >Actually, give password to everyone, and see who breaks it first.
> 
> you admit that AA isn't designed for this and then you set this as the 
> test, doesn't that seem unreasonable to you?

httpd's run at root priviledge, AFAICT, and Crispin just accused
someone of spreading fud. Exploited httpd is root shell.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
