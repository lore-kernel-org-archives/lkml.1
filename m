Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbYBZTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbYBZTyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYBZTyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:54:04 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36516 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYBZTyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:54:03 -0500
Date: Tue, 26 Feb 2008 21:52:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, mikael.starvik@axis.com,
       dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch v2] cris: proper defconfig setup
Message-ID: <20080226195257.GA4898@cs181133002.pp.htv.fi>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi> <20080226174703.GD8287@cs181133002.pp.htv.fi> <20080226180402.GH24124@axis.com> <20080226194453.GB31438@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080226194453.GB31438@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 08:44:53PM +0100, Sam Ravnborg wrote:
> On Tue, Feb 26, 2008 at 07:04:02PM +0100, Jesper Nilsson wrote:
> > On Tue, Feb 26, 2008 at 07:47:03PM +0200, Adrian Bunk wrote:
> > > This patch moves the cris defconfigs to arch/cris/configs/ where they 
> > > belong.
> > > 
> > > As a side effect they can now be used directly through e.g.
> > >   make ARCH=cris artpec_3_defconfig
> > > 
> > > The default defconfig is set through KBUILD_DEFCONFIG.
> > > 
> > > Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> > 
> > > Patch updated after I discovered an additional defconfig in 
> > > arch/cris/arch-v10/defconfig
> > 
> > That could probably have been nuked, it's ancient.
> > 
> > I'll put this in my queue. Thanks!
> If you blindly apply this patch then make sure you do not end
> up with zero size files. They are disliked by the kerne and
> make distclean will delete them - and git becomes unhappy.

At least GNU patch will correctly remove the files with my patch.

Please name the tools that are that broken that they wouldn't apply this 
patch correctly and don't claim my patch was broken (or shut up).

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

