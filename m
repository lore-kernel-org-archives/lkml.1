Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0CJIA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:00:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:60446 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751446Ab0CJIAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:00:24 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+rKnkIOEKrjlnzY7jh454UAiLxNb8rj4hFsI8eLp
	xd8n8pO8GpNPtx
Date: Wed, 10 Mar 2010 09:00:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Peter H?we <PeterHuewe@gmx.de>, Magnus Damm <damm@igel.co.jp>,
       linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] serial/sh_sci: Fix build failure for non-sh architectures
In-Reply-To: <20100310025301.GA17693@linux-sh.org>
Message-ID: <Pine.LNX.4.64.1003100854320.4618@axis700.grange>
References: <201003092118.26274.PeterHuewe@gmx.de> <20100310025301.GA17693@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Paul Mundt wrote:

> On Tue, Mar 09, 2010 at 09:18:25PM +0100, Peter H?we wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > This patch fixes a build failure for various arm based defconfigs
> > [1][2][3] and maybe other architectures/configs.
> > 
> > The build failure was introduced by the sh specific patch [4]
> > "serial: sh-sci: Add DMA support"
> > by Guennadi Liakhovetski
> > 
> > Patch against linux-next of 20100309
> 
> Please Cc linux-sh@vger.kernel.org so these things make it in to
> patchwork in the future.

Ok, I understand, this breakage is only in linux-next, and only for 
shmobile targets, which wasn't there as I was preparing the patch. 
However, what I did oversee is the H8300 arch, which also uses the 
sh-sci.c, and they are, probably, also broken in the mainline now. So, can 
we, please, also schedule this for 34-rc2?

> > References:
> > [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2248992/
> > [2] http://kisskb.ellerman.id.au/kisskb/buildresult/2248996/
> > [3] http://kisskb.ellerman.id.au/kisskb/buildresult/2248998/
> > [4] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=73a19e4c0301908ce6346715fd08a74308451f5a
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Applied, thanks.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
