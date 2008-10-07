Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYJGKQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYJGKQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYJGKPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:15:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:58421 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYJGKPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:15:54 -0400
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: Tejun Heo <tj@kernel.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Jeff Garzik <jgarzik@pobox.com>,
       Wang Jian <lark@linux.net.cn>
In-Reply-To: <20081007092605.GA28907@oksana.dev.rtsoft.ru>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	 <48EA77EF.6080502@genesi-usa.com>
	 <20081006213209.GA13072@oksana.dev.rtsoft.ru> <48EABBD3.1010401@kernel.org>
	 <20081007092605.GA28907@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 21:04:45 +1100
Message-Id: <1223373885.8157.49.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 13:26 +0400, Anton Vorontsov wrote:
> On Tue, Oct 07, 2008 at 10:30:59AM +0900, Tejun Heo wrote:
> > Anton Vorontsov wrote:
> > > On Mon, Oct 06, 2008 at 03:41:19PM -0500, Matt Sealey wrote:
> > >> There is a simple problem with the patch which is that an "IRQ 0" can and does
> > >> actually exist on a bunch of platforms, at least to the best of my knowledge.
> > >>
> > >> Checking for -1 (which means for definite, no irq at all, because it is
> > >> totally unambiguous, as a -1 IRQ numbering is "impossible") is more correct.
> > > 
> > > This was discussed years ago.
> > > 
> > > http://lkml.org/lkml/2005/11/22/159
> > > http://lkml.org/lkml/2005/11/22/227
> > > 
> > 
> > Would this break any existing platforms?
> 
> Nope.
> 
> The driver is only available for PPC platforms.
> 
> As time goes by one can change `depend on PPC_OF' to just `depends on
> OF', so that the driver will be also available for SPARC. And still
> it will work, because SPARC also understands VIRQ0 as invalid VIRQ.
> 

Yup, I agree. I'll pick it up in my next batch.

Cheers,
Ben.


