Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYH2IXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYH2IXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYH2IWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:22:34 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39032 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbYH2IWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:22:31 -0400
Date: Fri, 29 Aug 2008 11:21:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
Message-ID: <20080829082129.GF16462@cs181140183.pp.htv.fi>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <48B751DA.5090906@kernel.org> <20080829065026.GC16462@cs181140183.pp.htv.fi> <48B7A48B.8020405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B7A48B.8020405@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 09:26:03AM +0200, Tejun Heo wrote:
> Adrian Bunk wrote:
>...
> >> Anyways, the thing is that unlike what was originally expected, dropping
> >> an major programming API doesn't really work too well even after six
> >> years of trying.
> > 
> > Good ALSA emulation was a hot topic a few years ago when popular 
> > software like Flash and Skype didn't support ALSA, but the use
> > cases are becoming rare.
> > 
> > 2 out of your 3 examples above were software where native ALSA works,
> > but your distributions seems to ship you a setup where you thought 
> > OSS emulation was required.
> 
> Yeah, that's why I agree it's a bit too late but still better late than
> never.  There are just some programs, be it commercial or ancient, which
> don't work quite as well as it could.  Requiring update to ALSA took
> painfully long years and we're still not in the clear yet.  Now should
> we ask people to update to PA?
>...

Doesn't PA already emulate ALSA?

> ossp is simply a better way to support /dev/dsp on modern systems and
> bulk of it lives in userland (and I hope this can be the case for future
> deprecations too).  If for nothing else, it'll enable us to do away with
> three different emulations at the very least.  I mean we can't of course
> do away with padsp and then some still only work with aoss and then we
> need in-kernel ALSA OSS emulation as the final fallback when both fail.
>  It's a big mess and ossp can basically OSS emulation as good as
> in-kernel ALSA OSS w/ muxing.

The in-kernel OSS emulation also support OSS MIDI.

> Thanks.
> tejun

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

