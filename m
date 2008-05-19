Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbYESWKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbYESWKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765314AbYESWGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:06:44 -0400
Received: from xenotime.net ([66.160.160.81]:44452 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764824AbYESWGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:06:43 -0400
Date: Mon, 19 May 2008 15:06:41 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Adrian Bunk <bunk@kernel.org>, Rene Herman <rene.herman@gmail.com>,
       linux-kernel@vger.kernel.org, Adam M Belay <abelay@mit.edu>,
       Adam Belay <ambx1@neo.rr.com>
Subject: Re: [2.6 patch] pnp: remove printk() with outdated version
In-Reply-To: <200805191602.46460.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.64.0805191506300.20279@shark.he.net>
References: <20080519215419.GI17716@cs181133002.pp.htv.fi>
 <200805191602.46460.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Bjorn Helgaas wrote:

> On Monday 19 May 2008 03:54:19 pm Adrian Bunk wrote:
> > There's no point in printing some ancient version number forever.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Adam's the maintainer, so you really should ask him (cc'd).
> Personally, I agree that it isn't really useful anymore.

Ditto.  Thanks.

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
> >  
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
~Randy
