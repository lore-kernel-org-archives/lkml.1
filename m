Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYKJHu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYKJHu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYKJHuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:50:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYKJHuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:50:50 -0500
Date: Mon, 10 Nov 2008 08:50:49 +0100
From: Pavel Machek <pavel@suse.cz>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Cyril Hrubis <metan@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081110075048.GC707@atrey.karlin.mff.cuni.cz>
References: <20081105173303.GC2038@elf.ucw.cz> <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com> <20081106080416.GA1531@ucw.cz> <20081106191424.GA2273@atrey.karlin.mff.cuni.cz> <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com> <20081107142923.GA1616@ucw.cz> <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com> <20081109114545.GG6094@elf.ucw.cz> <20081109114640.GA10733@elf.ucw.cz> <bc64b4640811090430m195c421ejbf08375f4d9afd09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640811090430m195c421ejbf08375f4d9afd09@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2008/11/9 Pavel Machek <pavel@suse.cz>:
> > On Sun 2008-11-09 12:45:45, Pavel Machek wrote:
> >> On Fri 2008-11-07 17:57:33, Dmitry wrote:
> >> > 2008/11/7 Pavel Machek <pavel@suse.cz>:
> >> > > On Fri 2008-11-07 21:23:41, Eric Miao wrote:
> >> > >> Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
> >> > >> Did you guys ever try that?
> >> > >
> >> > > I never heard about that patch, do you have it handy?
> >> >
> >> > http://rpsys.net/openzaurus/patches/archive/pxa-linking-bug.patch
> >> >
> >> > I plan to submit a bit modified version of this patch later.
> >>
> >> Could you send me full .config that is known to work?
> >>
> >> Do I need pxa-linking-bug.patch to get it to boot?
> >
> > (Note that I'm booting using kexec, not sharp bootloader).
> 
> It seems that neither kexec, nor qemu require pxa-linking-bug.patch
> 
> Attached a .config that I use for testing. It contains all sharp zaurii
> selected, however you can easily deselect unnecessary ones.

Ugh, that one took quite a while to compile. Fortunately, this one
actually boots... (up to "launching init", anyway)... so the problem
seems to be config-dependend.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
