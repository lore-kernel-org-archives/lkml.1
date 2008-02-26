Return-Path: <linux-kernel-owner+w=401wt.eu-S1764604AbYBZTou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764604AbYBZTou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbYBZTol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:44:41 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42436 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbYBZTok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:44:40 -0500
Date: Tue, 26 Feb 2008 20:44:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Adrian Bunk <bunk@kernel.org>, mikael.starvik@axis.com, dev-etrax@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch v2] cris: proper defconfig setup
Message-ID: <20080226194453.GB31438@uranus.ravnborg.org>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi> <20080226174703.GD8287@cs181133002.pp.htv.fi> <20080226180402.GH24124@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226180402.GH24124@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:04:02PM +0100, Jesper Nilsson wrote:
> On Tue, Feb 26, 2008 at 07:47:03PM +0200, Adrian Bunk wrote:
> > This patch moves the cris defconfigs to arch/cris/configs/ where they 
> > belong.
> > 
> > As a side effect they can now be used directly through e.g.
> >   make ARCH=cris artpec_3_defconfig
> > 
> > The default defconfig is set through KBUILD_DEFCONFIG.
> > 
> > Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 
> > Patch updated after I discovered an additional defconfig in 
> > arch/cris/arch-v10/defconfig
> 
> That could probably have been nuked, it's ancient.
> 
> I'll put this in my queue. Thanks!
If you blindly apply this patch then make sure you do not end
up with zero size files. They are disliked by the kerne and
make distclean will delete them - and git becomes unhappy.


	Sam
