Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXFDNgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXFDNgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXFDNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:36:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38731 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbXFDNga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:36:30 -0400
Date: Mon, 4 Jun 2007 15:36:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jikos@jikos.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604133624.GA2059@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > CONFIG_BLINK=y
> > OOps. WTF is that?
> > 
> > config BLINK
> > 	tristate "Keyboard blink driver"
> > 	help
> > 	  Driver that when loaded will blink the keyboard LEDs
> > continuously.
> > 	  This is useful for debugging and for kernels that cannot
> > necessarily
> > 	  output something to the screen like kexec kernels to give
> > the user
> > 	  a visual indication that the kernel is doing something.
> > ..does it need "default n"? Why does it make keys stuck sometimes?
> 
> Are you sure that it's this dummy blink driver that makes the kernel 
> stuck? I can't see how it could be causing any hogs - see commit f038f9.
> 
> Anyway, added Andi to CC.

I'm not sure, and stuck keys are quite hard to reproduce. It only
happened twice in two days. But I've never seen stuck key on this
thinkpad x60 before, so...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
