Return-Path: <linux-kernel-owner+w=401wt.eu-S1763877AbYESWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763877AbYESWZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYESWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:24:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45743 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbYESWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:24:56 -0400
Date: Tue, 20 May 2008 01:22:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       Adam M Belay <abelay@mit.edu>, Adam Belay <ambx1@neo.rr.com>
Subject: Re: [2.6 patch] pnp: remove printk() with outdated version
Message-ID: <20080519222250.GA17716@cs181133002.pp.htv.fi>
References: <20080519215419.GI17716@cs181133002.pp.htv.fi> <200805191602.46460.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805191602.46460.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:02:46PM -0600, Bjorn Helgaas wrote:
> On Monday 19 May 2008 03:54:19 pm Adrian Bunk wrote:
> > There's no point in printing some ancient version number forever.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Adam's the maintainer, so you really should ask him (cc'd).

Sorry, I thought there was a patch pending listing you as the new 
maintainer, but that could be an error on my side.

> Personally, I agree that it isn't really useful anymore.
> 
> > ---
> > acef517cfbe3cd741f8884311ef6fc2dfbeb1a4d diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
> > index 20771b7..d924798 100644
> > --- a/drivers/pnp/core.c
> > +++ b/drivers/pnp/core.c
> > @@ -209,7 +209,6 @@ void __pnp_remove_device(struct pnp_dev *dev)
> >  
> >  static int __init pnp_init(void)
> >  {
> > -	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
> >  	return bus_register(&pnp_bus_type);
> >  }

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

