Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXDCQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXDCQDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXDCQDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:03:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2696 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753507AbXDCQDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:03:30 -0400
Date: Tue, 3 Apr 2007 16:03:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: Andi Kleen <andi@firstfloor.org>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, indan@nul.nu
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Message-ID: <20070403160307.GA5266@ucw.cz>
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com> <20070402132820.GA28983@one.firstfloor.org> <46111D03.5020905@sciensis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46111D03.5020905@sciensis.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>The best environment to deploy such functionality is 
> >>in updating by remote,
> >>executable code (programs, libs and modules) on 
> >>embedded devices running
> >>Linux, that have some form of kernel physical 
> >>security, so one can't 
> >
> >How would that physical security look like? Would it 
> >include DMA
> >protection?
> >
> >For example to do any useful form of graphics you need
> >user controllable DMA, which can normally touch 
> >everything.
> >There are various other similar "backdoors" for root.
> >
> >I'm somewhat sceptical because all kernels will need 
> >access
> >to the direct mapping to operate and there are also 
> >various
> >interfaces that can be as root (ab)used to change it.
> >
> >And when you can do that they can change function 
> >pointers
> >and jump to arbitary code or change the kernel page 
> >tables
> >and map arbitary code.
> >
> >Disallowing all this would probably end up with a quite
> >useless kernel. 
> >
> >  
> >>There are already some systems that implement and 
> >>utilize such functionality that
> >>use windows platforms, and other Linux distros that 
> >>use userland 
> >
> >Yes, at least the Vista variant was just broken. And 
> >its designers spent
> >a lot of effort on it, but it didn't help.
> >  
> Please read the thread i gave you for some details for 
> things you ask
> 
> Have in thought that we mostly talk here about embedded 
> devices
> that run Linux in a very restricted environment where 
> only specific
> applications are allowed to exist and run, there are no 
> user logons
> and these applications need to be updated by remote once 
> in a while
> over public networks. These applications need not be 
> tampered with

What kind of applications are we talking about here? I'd like to hack
hardware I own.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
