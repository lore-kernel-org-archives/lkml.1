Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXGDThf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXGDThf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXGDTh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:37:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48838 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755109AbXGDTh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:37:27 -0400
Date: Wed, 4 Jul 2007 21:37:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070704193711.GG2728@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz> <20070703071237.GA17476@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703071237.GA17476@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Perhaps one of you geniuses who all hate it can find a better way to
> > > > > solve the "video output dead after kexec; but need visual feedback to the user
> > > > > while crash dumping" problem. I'm waiting for your patches.
> > > > >
> > > > 
> > > > I don't don't like it ;) Unfortunately too many people end up enabling
> > > 
> > > Yes that's pretty weird. I admit I hadn't expected
> > > that problem. blink is equivalent to "annoy me" and it
> > > is a mystery why so many people should willingly ask their computer to 
> > > annoy them.
> > 
> > tristate "Keyboard blink driver"
> > 
> > ...drivers are not expected to act on their own. I was expecting to
> > get nice /sys/class/led* interface to my keyboard leds.
> 
> What's the benefit of such an interface? If you're able to trigger
> keyboard LEDs via that interface, you're also able to use the ioctl()
> on /dev/console.

Well, at least it is standartized interface... plus it can do stuff
like "blink that led on disk access".

> I think the intention of the blink driver was to have a *early* blink,
> i.e. before initrd (and on systems without intrd, before the first
> init script runs).

...and yes, it can autoblink, too. It should be even possible to set
default behaviour of led to blink, doing what the blink driver does,
but in a clean way.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
