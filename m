Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXGYTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXGYTyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXGYTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:54:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:51108 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750982AbXGYTyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:54:45 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1888woXM6c8/73CG6UzkvfnUWCaVvISo1zkZGunOC
	peqJtVYDIOWP1v
Date: Wed, 25 Jul 2007 21:54:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
In-Reply-To: <46A7A8FB.5090909@ru.mvista.com>
Message-ID: <Pine.LNX.4.60.0707252150540.6234@poirot.grange>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
 <Pine.LNX.4.60.0707252130090.6234@poirot.grange> <46A7A8FB.5090909@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Sergei Shtylyov wrote:

> Guennadi Liakhovetski wrote:
> 
> > > This is now very similar to pata_platform.c, they both use
> > > same platform data structure and same resources.
> 
> > > To achieve that, byte_lanes_swapping platform data variable
> > > and platform specified iops removed from that driver. It's fine,
> > > since those were never used anyway.
> 
> > > pata_platform and ide_platform are carrying same driver names,
> > > to easily switch between these drivers, without need to touch
> > > platform code.
> 
> > Why? There's a drivers/ide/arm/ide_arm.c IDe driver that some platforms (not
> > in the mainline) hack to access, e.g., CF cards in true-IDE mode. About a
> > month ago I submitted a patch to arm-linux-kernel switching that 
> 
>    Wrong list to submit sych stuff, post to linux-ide.

Not entirely. The patch (or other patches in the series) would also touch 
ARM platforms in the mainline, currently using that driver. As I didn't 
have a chance to test them due to lack of hardware, I posted on arm, 
asking if anyone would test those platforms for me.

> > driver to using platform-device. I got a reply, that it's not worth it now
> > that IDE is slowly becoming obsolete, and the pata_platform serves the
> > perpose perfectly well. I found this argument reasonable, I had the same
> 
>    Ignore such replies in the future. ;-)

It was largely in accordance with my own opinion, so, I chose to accept 
it:-)

> > doubt, just wanted to double-check. So, why do we now need a new legacy
> > (a/drivers/ide/legacy/ide_platform.c) driver when a "modern" driver exists?
> 
>    Good question (I know the answer but won't tell ;-).

You've been very cooperative, thanks.

Thanks
Guennadi
---
Guennadi Liakhovetski
