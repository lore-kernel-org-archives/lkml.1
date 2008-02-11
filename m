Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbYBKQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbYBKQvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYBKQvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:51:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54762 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758381AbYBKQvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:51:04 -0500
Date: Mon, 11 Feb 2008 18:50:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080211165055.GA2959@cs181133002.pp.htv.fi>
References: <20080128220944.GI8767@does.not.exist> <20080201152227.GB32085@elte.hu> <20080204204555.GC505@cs181133002.pp.htv.fi> <20080211163740.GA2446@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080211163740.GA2446@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 05:37:40PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > >     make ARCH=i386 randconfig
> > > 
> > > on a 64-bit box that has a 32-bit .config in its kernel directory.
> > > 
> > > The randconfig/allyesconfig/allnoconfig variants override whatever 
> > > is in the current .config. Making the result depend on whatever is 
> > > in the .config at the moment is fundamentally wrong.
> > > 
> > > "oldconfig" on the other hand has correct sensitivity to the 
> > > existing .config - and that always worked correctly. So if you pop a 
> > > 32-bit or a 64-bit .config into a kernel tree, that will be listened 
> > > to, no matter whether you are on a 32-bit or on a 64-bit host.
> > 
> > Do you have ARCH=x86 set in your environment, the command line or 
> > patched into your Makefile when this works for you?
> 
> nope, it happens with vanilla and no ARCH environment variable set that 
> i know of. So you cannot see this behavior?

No.

In my experience there is no way for me to enable 64BIT without somehow 
manually fiddling with ARCH.

No matter whether it's menuconfig or oldconfig or whatever else.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

