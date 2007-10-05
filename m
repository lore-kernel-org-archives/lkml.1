Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXJEGJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXJEGJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXJEGJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:09:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38701 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXJEGJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:09:38 -0400
Date: Fri, 5 Oct 2007 08:11:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071005061106.GA27798@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <200710022351.48971.alistair@devzero.co.uk> <20071005053813.GA25242@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005053813.GA25242@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory
> > 
> > Obviously, this file has moved to arch/x86/boot, but it seems like 
> > possibly unnecessary breakage. I've been copying bzImage for years 
> > from arch/x86_64/boot, and I'm sure there's a handful of scripts 
> > (other than Debian's kernel-image) doing this too.
> > 
> > For now, I hacked the tool[1]. Maybe, if we care, a symlink could be 
> > set up between arch/x86/boot and arch/$ARCH/boot ? Or would papering 
> > over this be more trouble than it's worth?
> 
> yeah, a symlink is the right solution i think. Our first-step goal is to 
> make the switchover seamless for all practical purposes, and a 
> compatibility symlink in arch/i386/boot/ will not hurt. (we shouldnt 
> worry about the really old zImage target though)

But when can we then get rid of it?
This is a simple question about when we take the noise..
And right now people know we are shifting to x86 - so it makes
sense to let the dependent userspace tools take the pain now and not later.

Starting to fill up a build kernel with symlinks for compatibility with
random progarms seems to be the wrong approach.

	Sam - that dislike especially the asm symlink
