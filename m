Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbYEFMup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbYEFMup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYEFMuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:50:35 -0400
Received: from www.tglx.de ([62.245.132.106]:36904 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbYEFMue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:50:34 -0400
Date: Tue, 6 May 2008 14:49:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Salomon <dilinger@queued.net>
cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080505112917.7d4548fb@ephemeral>
Message-ID: <alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de>
References: <20080504193113.GA24358@elte.hu> <20080505151202.GA17139@cs181133002.pp.htv.fi> <20080505112917.7d4548fb@ephemeral>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Andres Salomon wrote:
> On Mon, 5 May 2008 18:12:02 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sun, May 04, 2008 at 09:35:42PM +0200, Ingo Molnar wrote:
> > >...
> > > Thomas Gleixner (2):
> > >...
> > >       x86: olpc build fix
> > >...
> > > --- a/arch/x86/Kconfig
> > > +++ b/arch/x86/Kconfig
> > > @@ -1661,6 +1661,7 @@ config GEODE_MFGPT_TIMER
> > >  
> > >  config OLPC
> > >  	bool "One Laptop Per Child support"
> > > +	depends on MGEODE_LX
> > >  	default n
> > >  	help
> > >...
> > 
> > This patch not only excludes OLPC and code depending on it (currently 
> > BATTERY_OLPC) from all{mod,yes}config builds (where it built fine) 
> > but also makes it very hard for generic distribution kernels to
> > support the OLPC.
> > 
> > The commit comment does not indicate what the actual problem was, and
> > if this patch was sent to linux-kernel I must have missed it.
> > 
> > What exactly was the build problem?
> > Can we fix it in a less invasive way?
> 
> Also, it would've been nice to have been CC'd on this; I didn't see it
> until it was committed.

Sorry, this should not have gone mainline. We had your patch queued
(via Andrew) and it had testing failures, which we sent to you. One
workaround was that build patch. When we dropped your patch we forgot
to remove the workaround as well.

Thanks,

	tglx
