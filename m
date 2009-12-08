Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZLHIUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZLHIUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZLHIUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:20:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:46276 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753194AbZLHIUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:20:33 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19QGhRBrQhQ2q27lwyedszrG2lmNBx9MfLj5wFwhz
	bWXmB8hGOwoEyN
Date: Tue, 8 Dec 2009 09:20:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH 4/5] sh: stylistic improvements for the DMA driver
In-Reply-To: <e9c3a7c20912071654y19313fd5j6d9ff5a62cde028e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912080916300.4948@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange> 
 <Pine.LNX.4.64.0912041942040.3981@axis700.grange>
 <e9c3a7c20912071654y19313fd5j6d9ff5a62cde028e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Dan Williams wrote:

> On Fri, Dec 4, 2009 at 11:45 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/dma/shdma.c |   34 +++++++++++++++++-----------------
> >  drivers/dma/shdma.h |   14 +++++++-------
> >  2 files changed, 24 insertions(+), 24 deletions(-)
> >
> [..]
> > -static int dmae_is_idle(struct sh_dmae_chan *sh_chan)
> > +static int dmae_is_busy(struct sh_dmae_chan *sh_chan)
> 
> This one isn't purely style, I agree with it, but think it would be a
> bit cleaner to return a bool rather than an error code.

Yes, I also thought about it, but I wasn't sure whether the author had 
some special considerations, why he has chosen to return an error code. 
Besides, that return code is also used in functions dmae_set_chcr() and 
dmae_set_dmars() as their return value. So, you'd have to change those two 
to something like

	if (dmae_is_busy(sh_chan))
		return -EBUSY;

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
