Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXFDOOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXFDOOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXFDONx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:13:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55464 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753567AbXFDONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:13:52 -0400
Date: Mon, 4 Jun 2007 16:13:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: thinkpad testers wanted (was Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?)
Message-ID: <20070604141345.GB2059@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Anyway, added Andi to CC.
> >>
> >> Hmm, in theory it could be triggering bugs in some buggy keyboard
> >> controller. But then a
> >>
> >> while true ; do setleds +caps +numlock ; sleep 1 ; setleds -caps 
> >-numlock ;
> >> sleep 1 ; done
> >>
> >> should trigger it too.
> >
> >...and it does.
> >
> >pavel@amd:~$ while true; do setleds +num; setleds -num; done
> >Hm,m so thiis  iis  a teest of fkeyboarad behaviour  under lloadd.
> >
> >pavel@amd:~$
> >
> >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> >often. Launch the line above and try to do some typing...
> 
> This used to work fine on my box last time I tried it (the switch
> itself is offloaded to a keventd and shoud not get in the way) but
> then they push all kind of ACPI/SMM crap together with KBC so who
> knows... I should try it again when I get home.

Hmm, this needs to be ran from console (not X). Can someone with
thinkpad try this?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
