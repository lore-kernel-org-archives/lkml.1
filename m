Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbZE1P3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbZE1P3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZE1P3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:29:37 -0400
Received: from www.tglx.de ([62.245.132.106]:41095 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbZE1P3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:29:36 -0400
Date: Thu, 28 May 2009 17:27:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
In-Reply-To: <20090528150409.GO22742@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0905281721140.3397@localhost.localdomain>
References: <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk>
 <20090527205218.GA5591@sirena.org.uk> <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com> <20090528124307.GN22742@pengutronix.de> <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain> <20090528150409.GO22742@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Sascha Hauer wrote:
> > That does not help at all when your board has 5 variants just
> > different in subtle details which can not be probed or enumerated by
> > inspection. That's a common scenario in the embedded world.
> 
> We normally hide these subtle details behind a baseboard= kernel
> parameter. I agree with you that it's far better to have a standardized
> way to specify this. For my taste the oftree is too bloated for this
> purpose.

Well, with the baseboard= you still have to hack the details into the
kernel, which just adds code which needs to be maintained. I really
can do without 20 different platform structs and switch cases which
init GPIOs if there is an elegant way to describe the pin routing and
such. If you get your configuration out of OF tree then you can handle
this w/o even touching the kernel in most cases.

> > There is no need to force switch all of ARM to the device tree, but
> > adding support for it would be a good move. Nobody wants to enforce it
> > and both models can live happily side by side and we'll see which
> > variant turns out to be the long term favourite solution.
> 
> Having it as an optional feature seems a good idea for the same reasons
> you mentioned. I just wonder how optional it can be once a board
> maintainer and a person sending patches disagree on whether to use oftree
> or not.

As always it will be discussed on technical grounds. :)

Thanks,

	tglx
