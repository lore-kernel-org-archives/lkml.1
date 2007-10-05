Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXJEFin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXJEFin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXJEFig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:38:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbXJEFif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:38:35 -0400
Date: Fri, 5 Oct 2007 07:38:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071005053813.GA25242@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <200710022351.48971.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710022351.48971.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alistair John Strachan <alistair@devzero.co.uk> wrote:

> On Tuesday 02 October 2007 04:41:49 Linus Torvalds wrote:
> [snip]
> > In other words, people who know they may be affected and would want to
> > prepare can look at (for example)
> >
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86
> >
> > and generally get ready for the switch-over.
> 
> This is certainly a tool issue, but if I use Debian's kernel-image "make-kpkg" 
> wrapper around the kernel build system, it fails with:
> 
> cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory
> 
> Obviously, this file has moved to arch/x86/boot, but it seems like 
> possibly unnecessary breakage. I've been copying bzImage for years 
> from arch/x86_64/boot, and I'm sure there's a handful of scripts 
> (other than Debian's kernel-image) doing this too.
> 
> For now, I hacked the tool[1]. Maybe, if we care, a symlink could be 
> set up between arch/x86/boot and arch/$ARCH/boot ? Or would papering 
> over this be more trouble than it's worth?

yeah, a symlink is the right solution i think. Our first-step goal is to 
make the switchover seamless for all practical purposes, and a 
compatibility symlink in arch/i386/boot/ will not hurt. (we shouldnt 
worry about the really old zImage target though)

	Ingo
