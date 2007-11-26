Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbXKZS5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbXKZS5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXKZS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:57:30 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54311 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078AbXKZS5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:57:30 -0500
Date: Mon, 26 Nov 2007 19:57:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20071126185716.GA917@stusta.de>
References: <20071125161631.GA21947@stusta.de> <20071126122706.GA5167@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071126122706.GA5167@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 12:27:07PM +0000, Pavel Machek wrote:
> On Sun 2007-11-25 17:16:31, Adrian Bunk wrote:
> > This patch removes the EXPERIMENTAL option and all dependencies on 
> > EXPERIMENTAL because they are pointless.
> > 
> > Complete rationale:
> > - Many people and all distributions are currently forced to enable
> >   CONFIG_EXPERIMENTAL since the options for many device drivers depend
> >   on this option.
> >   I have yet to see someone not being able to install his favorite
> >   distribution on his computer only because the distribution did choose
> >   to disable all SATA drivers with dependencies on EXPERIMENTAL in their
> >   kernels...
> > - History has shown that often the dependency on EXPERIMENTAL is not
> >   removed when the code has proven usable.
> >   As an example, is our NFSv4 support really still in an
> >   "alpha-test phase" [1], or is it already ready for being used?
> >   I don't know the answer in this specific case, but I wouldn't answer
> >   "still in an alpha-test phase" only based on the fact that the NFSv4
> >   options still depend on EXPERIMENTAL.
> > - It might have been differently 10 years ago, but today everything that
> >   is available in a released kernel should also be in a usable state.
> > 
> > [1] quoted from the CONFIG_EXPERIMENTAL help text
> 
> I don't think this is good idea. But perhaps 'experimental' should be
> removed from stuff that is really stable these days, like SATA?

It's not the SATA subsystem itself that is experimental.
There are some some drivers that are still experimental.

That's the same like e.g. with network drivers where the subsystem is 
stable but some drivers are not (yet).

And therefore people are forced to enable CONFIG_EXPERIMENTAL for 
getting the kernel running on their hardware.

But e.g. the fact that a user must enable an experimental SATA driver 
does not imply he also wants experimental network subsystem features.

> 							Pavel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

