Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZIUTU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZIUTU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZIUTU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:20:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:46875 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753184AbZIUTUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:20:25 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+Ot0B0lyWO7+dT4EzWoZjgmjdDyVEIJy55VGMptq
	TWsTcJNxJ0K8tF
Date: Mon, 21 Sep 2009 21:19:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: What's inside the pxa tree for this merge window
In-Reply-To: <20090918074551.GA26058@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0909212111490.17328@axis700.grange>
References: <f17812d70909100446h17a1903fy74941945dbfc6943@mail.gmail.com>
 <1253256227.4407.7.camel@pc-matejk> <20090918074551.GA26058@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Russell King - ARM Linux wrote:

> On Fri, Sep 18, 2009 at 08:43:47AM +0200, Matej Kenda wrote:
> > On Thu, 2009-09-10 at 19:46 +0800, Eric Miao wrote:
> > > Here's the preview of request-pull result, please let me know if there
> > > is anything missed, thanks.
> > > 
> > > URL: git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
> > > 
> > > 
> > > Matej Kenda (2):
> > >       [ARM] pxa: add support for the IskraTel XCEP board
> > >       [ARM] pxa: add defconfig for IskraTel XCEP board
> > 
> > Eric, what is the current status of this request? Do I need to repost
> > the patches to included into 2.6.32?
> > 
> > Russell discarded them from his patch system, because they are on your
> > list.
> 
> I discarded them _because_ Eric handled them, which is what I said in the
> comments when I discarded them.

Ok, I did do my best to get patches in the right order in the mainline, 
but it all failed. AFAICS, v4l and sh are already in the mainline with a 
_wrongly_ resolved mefge conflict, which, most likely, breaks the 
sh_mobile_ceu_camera.c driver, and the three PXA platforms, patches for 
which should have been applied before both those trees and still haven't 
been applied are broken until the patches do get in and the later those 
patches get applied the longer the interval with the broken for them 
bisection is going to be.

Thanks
Guennadi
---
Guennadi Liakhovetski
