Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbYJMT1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbYJMT1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbYJMT1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:27:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:58924 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753650AbYJMT1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:27:35 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18vAM4KU4Yv1B7e1F2Hgxl2tKfcvssRyMTTI8HEOQ
	ABml8S47I3IVfx
Date: Mon, 13 Oct 2008 21:27:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Wood <scottwood@freescale.com>
cc: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
In-Reply-To: <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
Message-ID: <Pine.LNX.4.64.0810132119510.9041@axis700.grange>
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br>
 <Pine.LNX.4.64.0810132003350.9041@axis700.grange>
 <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Scott Wood wrote:

> On Mon, Oct 13, 2008 at 08:05:09PM +0200, Guennadi Liakhovetski wrote:
> > On Mon, 13 Oct 2008, Rogério Brito wrote:
> > 
> > > The current defconfig for Linkstation/Kuroboxes has the "Disable Heap
> > > Randomization" option enabled.
> > > 
> > > Since some of these machines are facing the internet, it helps to have
> > > heap randomization enabled. This patch enables it.
> > 
> > Same as the previous patch - this is one of options, that users select 
> > according to their needs. If any specific distribution enables this option 
> > by default in their kernels, they can do this too, don't think this is 
> > critical enough to patch the defconfig.
> 
> Just because users/distros can change it doesn't mean it's pointless to
> discuss what default is sane, and make changes if the current default
> isn't.
> 
> For security-related options it's usually best to default to the more
> secure state, especially since the option description talks about it
> being needed mainly for libc5 compatibility -- did libc5 ever even exist
> for powerpc?  

In a 2.6.27-rc5-ish snapshot I counted 68 enabled and 11 disabled 
CONFIG_COMPAT_BRK under arch/powerpc/configs/. Ok, enabling it for all 
would be a bit rude, and one has to start somewhere...

> The only reason it was turned on in the first place was likely the
> "default y", which in turn is there to avoid breaking old x86 distros.

Then maybe it would be better to make default y only for some platforms?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
