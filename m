Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0CJIJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:09:37 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37807 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab0CJIJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:09:35 -0500
Date: Wed, 10 Mar 2010 17:08:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Peter H?we <PeterHuewe@gmx.de>, Magnus Damm <damm@igel.co.jp>,
       linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] serial/sh_sci: Fix build failure for non-sh architectures
Message-ID: <20100310080841.GF19518@linux-sh.org>
References: <201003092118.26274.PeterHuewe@gmx.de> <20100310025301.GA17693@linux-sh.org> <Pine.LNX.4.64.1003100854320.4618@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003100854320.4618@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 09:00:24AM +0100, Guennadi Liakhovetski wrote:
> On Wed, 10 Mar 2010, Paul Mundt wrote:
> 
> > On Tue, Mar 09, 2010 at 09:18:25PM +0100, Peter H?we wrote:
> > > From: Peter Huewe <peterhuewe@gmx.de>
> > > 
> > > This patch fixes a build failure for various arm based defconfigs
> > > [1][2][3] and maybe other architectures/configs.
> > > 
> > > The build failure was introduced by the sh specific patch [4]
> > > "serial: sh-sci: Add DMA support"
> > > by Guennadi Liakhovetski
> > > 
> > > Patch against linux-next of 20100309
> > 
> > Please Cc linux-sh@vger.kernel.org so these things make it in to
> > patchwork in the future.
> 
> Ok, I understand, this breakage is only in linux-next, and only for 
> shmobile targets, which wasn't there as I was preparing the patch. 
> However, what I did oversee is the H8300 arch, which also uses the 
> sh-sci.c, and they are, probably, also broken in the mainline now. So, can 
> we, please, also schedule this for 34-rc2?
> 
Yes, it's in my .34 queue. H8300 doesn't actually matter though, since
they've never converted in-tree to using sh-sci through the driver model.
It likely hasn't been tested on H8 since 2.5, so I'm not exactly losing
sleep over it.
