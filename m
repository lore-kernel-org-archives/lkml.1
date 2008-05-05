Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYEEP01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYEEP01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbYEEPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:25:42 -0400
Received: from mail.queued.net ([207.210.101.209]:1464 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760088AbYEEPZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:25:40 -0400
Date: Mon, 5 May 2008 11:29:17 -0400
From: Andres Salomon <dilinger@queued.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080505112917.7d4548fb@ephemeral>
In-Reply-To: <20080505151202.GA17139@cs181133002.pp.htv.fi>
References: <20080504193113.GA24358@elte.hu>
	<20080505151202.GA17139@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 18:12:02 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Sun, May 04, 2008 at 09:35:42PM +0200, Ingo Molnar wrote:
> >...
> > Thomas Gleixner (2):
> >...
> >       x86: olpc build fix
> >...
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1661,6 +1661,7 @@ config GEODE_MFGPT_TIMER
> >  
> >  config OLPC
> >  	bool "One Laptop Per Child support"
> > +	depends on MGEODE_LX
> >  	default n
> >  	help
> >...
> 
> This patch not only excludes OLPC and code depending on it (currently 
> BATTERY_OLPC) from all{mod,yes}config builds (where it built fine) 
> but also makes it very hard for generic distribution kernels to
> support the OLPC.
> 
> The commit comment does not indicate what the actual problem was, and
> if this patch was sent to linux-kernel I must have missed it.
> 
> What exactly was the build problem?
> Can we fix it in a less invasive way?

Also, it would've been nice to have been CC'd on this; I didn't see it
until it was committed.

