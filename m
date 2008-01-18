Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbYARR3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbYARR3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbYARR1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:44 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49929 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbYARR1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:42 -0500
Date: Fri, 18 Jan 2008 19:26:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118172630.GD28233@does.not.exist>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu> <20080118170037.GA23297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080118170037.GA23297@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:00:37PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > >  # Select 32 or 64 bit
> > >  config 64BIT
> > > -	bool "64-bit kernel" if ARCH = "x86"
> > > +	bool "64-bit kernel"
> > >  	default ARCH = "x86_64"
> > >  	help
> > >  	  Say yes to build a 64-bit kernel - formerly known as x86_64
> > 
> > thx, i've added this to x86.git.
> 
> this broke "make ARCH=i386 randconfig" from working when there's a 
> 64-bit .config present. (it will not properly generate a 32-bit config, 
> but still a 64-bit config)

Does it always generate a 64bit .config or randomly a 32bit or 64bit 
.config?

As far as I see it's the latter.

If the unified x86 architecture should be presented as one 
architecture in kconfig that's expected - and it might even reduce the 
amount of 32bit compile errors that recently occured in the git-x86 
tree...

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

