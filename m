Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbXJGXo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbXJGXo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXJGXow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:44:52 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:57897 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbXJGXov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:44:51 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Date: Mon, 8 Oct 2007 00:44:49 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071005061106.GA27798@uranus.ravnborg.org> <alpine.LRH.0.999.0710051026200.10191@www.tglx.de>
In-Reply-To: <alpine.LRH.0.999.0710051026200.10191@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710080044.49883.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 09:32:40 you wrote:
> On Fri, 5 Oct 2007, Sam Ravnborg wrote:
> > > > cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory
> > > >
> > > > Obviously, this file has moved to arch/x86/boot, but it seems like
> > > > possibly unnecessary breakage. I've been copying bzImage for years
> > > > from arch/x86_64/boot, and I'm sure there's a handful of scripts
> > > > (other than Debian's kernel-image) doing this too.
> > > >
> > > > For now, I hacked the tool[1]. Maybe, if we care, a symlink could be
> > > > set up between arch/x86/boot and arch/$ARCH/boot ? Or would papering
> > > > over this be more trouble than it's worth?
> > >
> > > yeah, a symlink is the right solution i think. Our first-step goal is
> > > to make the switchover seamless for all practical purposes, and a
> > > compatibility symlink in arch/i386/boot/ will not hurt. (we shouldnt
> > > worry about the really old zImage target though)
> >
> > But when can we then get rid of it?
> > This is a simple question about when we take the noise..
> > And right now people know we are shifting to x86 - so it makes
> > sense to let the dependent userspace tools take the pain now and not
> > later.
> >
> > Starting to fill up a build kernel with symlinks for compatibility with
> > random progarms seems to be the wrong approach.
> >
> > 	Sam - that dislike especially the asm symlink
>
> Sam,
>
> I completely agree with you, but we want to keep the migration noise
> as low as possible. Adding the symlink right now along with an entry
> into features-removal.txt (6 month grace period) allows a smoother
> transition. The distro folks should better get their gear together
> until then.

I'll certainly file a bug report with the Debian BTS, but the fix will 
probably involve something as abortive as my original patch.

How did the PPC merge handle this? I can't see any similar hacks in 
kernel-image for these architectures.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
