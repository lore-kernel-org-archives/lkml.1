Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYH2Gvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYH2Gvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYH2Gv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:51:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53455 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYH2Gv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:51:28 -0400
Date: Fri, 29 Aug 2008 09:50:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
Message-ID: <20080829065026.GC16462@cs181140183.pp.htv.fi>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <48B751DA.5090906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B751DA.5090906@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 03:33:14AM +0200, Tejun Heo wrote:
> Adrian Bunk wrote:
> > Sorry for being destructive, but 6 years after ALSA went into the
> > kernel we are slightly approaching the point where all applications 
> > support ALSA.
> 
> Yeah, I have to agree it's a bit too late but the exclusion between OSS
> and more modern sound systems (be it ALSA or PA) still bugged me quite a
> bit.  There always seems this one off app that wasn't quite there - be
> it mpg123 for whatever reason I still enjoy to use from time to time,

mpg123 supports ALSA since 1998 (sic).

> vmware which is a genuine pain in the ass to get working with LD_PRELOAD
> tricks (hopefully 6.5 will finally use ALSA but wait we're all going PA
> now...) or scorch-3D (and many other games) where aoss delivers horrible
> sound after playing for a while.

Scorched3D gives me sound with native ALSA.

Is your libSDL not linked with libasound?

>...
> Anyways, the thing is that unlike what was originally expected, dropping
> an major programming API doesn't really work too well even after six
> years of trying.

Good ALSA emulation was a hot topic a few years ago when popular 
software like Flash and Skype didn't support ALSA, but the use
cases are becoming rare.

2 out of your 3 examples above were software where native ALSA works,
but your distributions seems to ship you a setup where you thought 
OSS emulation was required.

Which distribution are you using whose makers seem to need
a big cluebat?

> Maybe because OSS is still kicking on other unices.

Which Unix with a big userbase uses OSS as primary sound system?

OSS-only applications tend to be older Linux-only applications.

Cross-platform applications either ship half a dozen different sound 
drivers (including ALSA), or more commonly use some library that offers
one API no matter which sound system gets used.

>...
> Thanks.
> tejun

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

