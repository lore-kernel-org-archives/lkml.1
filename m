Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYFCUVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYFCUVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYFCUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:20:58 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34276 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYFCUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:20:57 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 14/15] PNP: support optional IRQ resources
Date: Tue, 3 Jun 2008 14:20:59 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.156287156@ldl.fc.hp.com> <48458141.9020409@keyaccess.nl>
In-Reply-To: <48458141.9020409@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031421.00767.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 11:37:05 am Rene Herman wrote:
> > Index: work10/include/linux/ioport.h
> > ===================================================================
> > --- work10.orig/include/linux/ioport.h	2008-05-20 13:34:58.000000000 -0600
> > +++ work10/include/linux/ioport.h	2008-05-20 13:39:21.000000000 -0600
> > @@ -59,6 +59,7 @@ struct resource_list {
> >  #define IORESOURCE_IRQ_HIGHLEVEL	(1<<2)
> >  #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
> >  #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
> > +#define IORESOURCE_IRQ_OPTIONAL		(1<<5)
> >  
> >  /* ISA PnP DMA specific bits (IORESOURCE_BITS) */
> >  #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
> 
> Andrew scooped up a patch from a previous reaction of mine that deleted 
> the "ISA " from these comments. I tend to use comments as a great way of 
> avoiding actually reading code (I'm silly like that) and so as to be 
> burned a _bit_ less by it, I think it's good if they're accurate. In 
> this case for example, one might be tempted to assume these bits were 
> specific to drivers/pnp/isapnp.

Yes, I see that's pnpacpi-fix-irq-flag-decoding-comment-fix.patch
in mmotm.  How about if I incorporate that in my series (the one
Andrew hasn't yet picked up), since your patch will otherwise
conflict with it?

Bjorn
