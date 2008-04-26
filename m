Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbYDZTdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbYDZTdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbYDZTcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:32:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3480 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759516AbYDZTcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:32:32 -0400
Date: Sat, 26 Apr 2008 09:43:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080426074300.GA3891@ucw.cz>
References: <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu> <20080421200949.GB2633@cs181133002.pp.htv.fi> <20080421201352.GM8770@elte.hu> <20080421202605.GC2633@cs181133002.pp.htv.fi> <20080421202919.GA28069@elte.hu> <20080421210232.GD2633@cs181133002.pp.htv.fi> <20080421223142.GA18140@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421223142.GA18140@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > Who said that Voyager won't boot?
> > > > > 
> > > > > Adrian, you build Voyager kernels so just try to boot it once on 
> > > > > your PC and watch the show ...
> > > > 
> > > > Ingo, an ia64 kernel also won't boot on my computer, and I'll 
> > > > still compile test my patches for ia64 ...
> > > 
> > > dont be silly... the ia64 kernel is not under arch/x86, it's not 
> > > even the same instruction format. Voyager runs on x86 CPUs and is 
> > > part of the x86 architecture tree.
> > 
> > Your point is?
> 
> my point is what i said and which you apparently did not understand:
> 
> | Adrian, could you please remove it from your config testset as well? 
> | If a user enables that config option it wont boot anyway so it's not a 
> | problem in practice.
> 
> > I'm compile testing 22 architectures (especially when sending my own 
> > patches), and whether a kernel would boot on my computer doesn't make 
> > any difference.
> 
> a user wont 'accidentally' install a crosscompiler toolchain to create 
> an unbootable kernel...

I guess Adrian is trying to say:

'That code is in tree, so it should compile and run. He can't verify
it runs, but he's trying to make sure it at least compiles.'

For 'normal' users it is not a problem.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
