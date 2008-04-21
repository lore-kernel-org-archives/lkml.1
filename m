Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYDUX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYDUX07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYDUX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:26:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:49605 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbYDUX0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:26:50 -0400
Date: Tue, 22 Apr 2008 01:26:49 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, bob.picco@hp.com,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC: 2.6 patch] MAINTAINERS: remove HPET entries
Message-ID: <20080421232649.GA3717@suse.cz>
References: <alpine.LFD.1.10.0804042019210.3224@apollo.tec.linutronix.de> <47F69621.3080105@garzik.org> <alpine.LFD.1.10.0804042339020.3224@apollo.tec.linutronix.de> <20080421213141.GG2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421213141.GG2633@cs181133002.pp.htv.fi>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 12:31:41AM +0300, Adrian Bunk wrote:
> On Fri, Apr 04, 2008 at 11:39:44PM +0200, Thomas Gleixner wrote:
> > On Fri, 4 Apr 2008, Jeff Garzik wrote:
> > > Thomas Gleixner wrote:
> > > > 1) drivers/char/hpet.c
> > > >    include/linux/hpet.h
> > > > 
> > > >    due to the revert of the HPET irq assignemt, which was only affects x86.
> > > 
> > > 
> > > Related to this...  check out jgarzik/misc-2.6.git#irq-cleanups and
> > > #irq-remove for my set of patches that remove the 'irq' argument from all irq
> > > handlers.
> > > 
> > > I have a couple cleanup patches for HPET that should go in prior to the big
> > > "remove irq argument" massive change (even if people don't want to remove the
> > > 'irq' argument ultimately, the cleanup is still useful)
> > > 
> > > Who is the HPET maintainer these days, if anyone?
> > 
> > Dunno. It usually ends up in one of my git sinks :(
> 
> So what about the patch below to avoid patches ending up at the wrong 
> people?

Sure, go ahead, now that there is no x86-64 arch, my entry doesn't even
make sense.

 
> We had 4 different MAINTAINERS entries for HPET, but effectively Thomas 
> currently is the maintainer.
> 
> Remove these entries - the already existing entry for X86 should be 
> better for handling to.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Vojtech Pavlik <vojtech@suse.cz>

> 
> ---
> 
>  MAINTAINERS |   20 --------------------
>  1 file changed, 20 deletions(-)
> 
> 4e4d08631d04846823443559dce6feaab4ce46f3 diff --git a/MAINTAINERS b/MAINTAINERS
> index 45b86ab..b0c075a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1840,26 +1840,6 @@ P:	Carlos Corbacho
>  M:	carlos@strangeworlds.co.uk
>  S:	Odd Fixes
>  
> -HPET:	High Precision Event Timers driver (hpet.c)
> -P:	Clemens Ladisch
> -M:	clemens@ladisch.de
> -S:	Maintained
> -
> -HPET:	i386
> -P:	Venkatesh Pallipadi (Venki)
> -M:	venkatesh.pallipadi@intel.com
> -S:	Maintained
> -
> -HPET:	x86_64
> -P:	Vojtech Pavlik
> -M:	vojtech@suse.cz
> -S:	Maintained
> -
> -HPET:	ACPI hpet.c
> -P:	Bob Picco
> -M:	bob.picco@hp.com
> -S:	Maintained
> -
>  HPFS FILESYSTEM
>  P:	Mikulas Patocka
>  M:	mikulas@artax.karlin.mff.cuni.cz
> 

-- 
Vojtech Pavlik
Director SuSE Labs
