Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbXGCHNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbXGCHNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbXGCHMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:12:44 -0400
Received: from mail.suse.de ([195.135.220.2]:45284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbXGCHMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:12:43 -0400
Date: Tue, 3 Jul 2007 09:12:37 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070703071237.GA17476@suse.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Andi Kleen <ak@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Indan Zupancic <indan@nul.nu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702230827.GA9071@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [2007-07-03 01:08]:
> On Mon 2007-07-02 14:39:27, Andi Kleen wrote:
> > 
> > > > Perhaps one of you geniuses who all hate it can find a better way to
> > > > solve the "video output dead after kexec; but need visual feedback to the user
> > > > while crash dumping" problem. I'm waiting for your patches.
> > > >
> > > 
> > > I don't don't like it ;) Unfortunately too many people end up enabling
> > 
> > Yes that's pretty weird. I admit I hadn't expected
> > that problem. blink is equivalent to "annoy me" and it
> > is a mystery why so many people should willingly ask their computer to 
> > annoy them.
> 
> tristate "Keyboard blink driver"
> 
> ...drivers are not expected to act on their own. I was expecting to
> get nice /sys/class/led* interface to my keyboard leds.

What's the benefit of such an interface? If you're able to trigger
keyboard LEDs via that interface, you're also able to use the ioctl()
on /dev/console.

I think the intention of the blink driver was to have a *early* blink,
i.e. before initrd (and on systems without intrd, before the first
init script runs).



Thanks,
   Bernhard
