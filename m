Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYICMHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYICMHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYICMHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:07:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50187 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYICMHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:07:08 -0400
Date: Wed, 3 Sep 2008 15:07:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] m68k: Reverse platform MMU logic so Sun 3 is last
Message-ID: <20080903120706.GE4104@cs181140183.pp.htv.fi>
References: <20080903071542.615137611@mail.of.borg> <20080903071741.424551678@mail.of.borg> <20080903073629.GD4104@cs181140183.pp.htv.fi> <1220440421.4159.22.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1220440421.4159.22.camel@frecb07144>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 01:13:41PM +0200, Laurent Vivier wrote:
> Le mercredi 03 septembre 2008 à 10:36 +0300, Adrian Bunk a écrit :
> > On Wed, Sep 03, 2008 at 09:15:44AM +0200, Geert Uytterhoeven wrote:
> > > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > > 
> > > Currently Sun 3 support is the first platform option, as the Sun 3 MMU is
> > > incompatible with standard Motorola MMUs. However, this means that
> > > `allmodconfig' enables support for Sun 3, and thus disables support for all
> > > other platforms.
> > >...
> > 
> > I hope it isn't too heretical to ask whether Sun 3 support actually has 
> > users and works?
> > 
> > Apollo support was broken for over 7 years without anyone noticing, and 
> > it might not be the only m68k platform that is long unused.
> > 
> > Do you have any overview of which m68k platforms still have users?
> 
> At least 4 users for amiga and 2 for mac :-P
> 
> #rank name                            inst  vote   old recent no-files
> 42014 linux-image-2.6-amiga              4     0     0     0     4
> 53844 linux-image-2.6-mac                2     0     0     0     2
> 
> from http://popcon.debian.org/by_inst
> 
> I'm a mac m68k user (who is the other one ???)

Debian 3.1 (the last release to support m68k) supported
Amiga, Atari, Mac and VME.

These were also the most popular m68k platforms at about
10 years ago. [1]

But what about the rest?

As long as a platform has at one or more users it is worth keeping it,
but at least for Apollo it seems to be clear that noone ever used
kernel 2.4 or 2.6 on this platform.

> Laurent

cu
Adrian

[1] http://www.linux-m68k.org/Registry/Statistics.html

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

