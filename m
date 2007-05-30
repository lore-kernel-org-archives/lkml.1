Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXE3G0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXE3G0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 02:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXE3G0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 02:26:33 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46421 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246AbXE3G0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 02:26:33 -0400
Date: Wed, 30 May 2007 08:26:31 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       Jakob Bornecrantz <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 1/3] allow console unregistration
In-Reply-To: <1180483232.10390.7.camel@daplas>
Message-ID: <Pine.LNX.4.62.0705300824340.16818@pademelon.sonytel.be>
References: <200705171423.46748.jesse.barnes@intel.com>
 <200705171532.28799.jesse.barnes@intel.com> <1180483232.10390.7.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Tony,

On Wed, 30 May 2007, Antonino A. Daplas wrote:
> On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> > Randy just informed me that the patch limits are bigger now, so here are the
> > actual patches.
> > 
> > This patch allows for proper console unregistration via the VT layer, and
> > updates the FB layer to use it.  This makes debugging new console drivers
> > much easier, since you can properly clean them up before unloading.
> > Antonio already checked it out (and suggested a tweak for the fbcon side)
> > so I think it's on its way already via the FB tree.
> > 
> 
> Jesse,
> 
> I already implemented (and tested) selective framebuffer/console
> unregistration in my tree using your patch as a base. I'll send this
> patch to akpm soon.
> 
> Geert,
> 
> Is this something that you might need for ps3fb? It should address 2 of
> your concerns. The only thing is that you will need
> CONFIG_VT_HW_CONSOLE_BINDING=y.  You can default this to 'y' in your
> platform, or select it.

I was going to look at Jesse's patch, but it didn't happen yet.
So yes, I'm definitely interested in your patch! Can you please send it to
linux-fbdev-devel already?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
