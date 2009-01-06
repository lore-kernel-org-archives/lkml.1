Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZAFNVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZAFNVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:21:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZAFNUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:20:52 -0500
Received: from www.tglx.de ([62.245.132.106]:32975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbZAFNUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:20:51 -0500
Date: Tue, 6 Jan 2009 14:20:25 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
Message-ID: <20090106132025.GB3057@local>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange> <20090106090422.GC18861@pengutronix.de> <Pine.LNX.4.64.0901061021180.5393@axis700.grange> <20090106101929.GD18861@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106101929.GD18861@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:19:29AM +0100, Sascha Hauer wrote:
> On Tue, Jan 06, 2009 at 10:51:37AM +0100, Guennadi Liakhovetski wrote:
> > Hi Sascha
> > 
> > On Tue, 6 Jan 2009, Sascha Hauer wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > On Fri, Dec 26, 2008 at 06:11:13PM +0100, Guennadi Liakhovetski wrote:
> > > > Hi,
> > > > 
> > > > This is version 6 of dmaengine and framebuffer drivers for i.MX31.
> > > > 
> > > > Changes since version 5: as requested by Sascha Hauer switched to dynamic 
> > > > IPU IRQ mapping.
> > > 
> > > I tried to express that it's really odd that you demux your _internal_
> > > interrupts as chained handlers.
> > 
> > Your last comment was:
> > 
> > > Preferably a way which does not involve introducing 100+ unused
> > > interrupts.
> > 
> > which I have done. Now we're back to demux / not demux...
> 
> Can *please* anybody else say something to this issue to calm this down?
> To make it easier for you please sign:
> 
> [ ] The code is fine the way it is. Sascha go home.
> [ ] The code could be better, but hey, it works and the world is not
>     perfect.
> [x] No, we shouldn't abuse chained interrupts for internal irq
>     dispatching.

Definitly the last one, for the reasons you gave in your last mail.
Using chained irqs is not the natural thing to do here.

Thanks,
Hans
