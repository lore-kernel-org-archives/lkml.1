Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbYEGPiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbYEGPiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbYEGPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:38:08 -0400
Received: from mail.queued.net ([207.210.101.209]:1855 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbYEGPiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:38:05 -0400
Date: Wed, 7 May 2008 11:41:37 -0400
From: Andres Salomon <dilinger@queued.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080507114137.357aca34@ephemeral>
In-Reply-To: <alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de>
References: <20080504193113.GA24358@elte.hu>
	<20080505151202.GA17139@cs181133002.pp.htv.fi>
	<20080505112917.7d4548fb@ephemeral>
	<alpine.LFD.1.10.0805061437430.3318@apollo.tec.linutronix.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 14:49:07 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 5 May 2008, Andres Salomon wrote:
> > On Mon, 5 May 2008 18:12:02 +0300
> > Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Sun, May 04, 2008 at 09:35:42PM +0200, Ingo Molnar wrote:
> > > >...
> > > > Thomas Gleixner (2):
> > > >...
> > > >       x86: olpc build fix
> > > >...
> > > > --- a/arch/x86/Kconfig
> > > > +++ b/arch/x86/Kconfig
> > > > @@ -1661,6 +1661,7 @@ config GEODE_MFGPT_TIMER
> > > >  
> > > >  config OLPC
> > > >  	bool "One Laptop Per Child support"
> > > > +	depends on MGEODE_LX
> > > >  	default n
> > > >  	help
> > > >...
> > > 
> > > This patch not only excludes OLPC and code depending on it
> > > (currently BATTERY_OLPC) from all{mod,yes}config builds (where it
> > > built fine) but also makes it very hard for generic distribution
> > > kernels to support the OLPC.
> > > 
> > > The commit comment does not indicate what the actual problem was,
> > > and if this patch was sent to linux-kernel I must have missed it.
> > > 
> > > What exactly was the build problem?
> > > Can we fix it in a less invasive way?
> > 
> > Also, it would've been nice to have been CC'd on this; I didn't see
> > it until it was committed.
> 
> Sorry, this should not have gone mainline. We had your patch queued
> (via Andrew) and it had testing failures, which we sent to you. One
> workaround was that build patch. When we dropped your patch we forgot
> to remove the workaround as well.
> 

Will it be removed, then?  I haven't seen any explanation of its
benefits, and Adrian's point about not catching build failures in
olpc_battery is valid.
