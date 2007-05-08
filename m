Return-Path: <linux-kernel-owner+w=401wt.eu-S969890AbXEHXcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969890AbXEHXcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969754AbXEHXbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:31:44 -0400
Received: from ozlabs.org ([203.10.76.45]:48792 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969749AbXEHXbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:31:44 -0400
Date: Wed, 9 May 2007 09:31:37 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Loeliger Jon-LOELIGER <jdl@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [POWERPC] dts: kill hardcoded phandles
Message-ID: <20070508233137.GB2112@localhost.localdomain>
Mail-Followup-To: Vitaly Bordug <vitb@kernel.crashing.org>,
	Loeliger Jon-LOELIGER <jdl@freescale.com>, linuxppc-dev@ozlabs.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070508053049.18428.50622.stgit@localhost.localdomain> <20070508054855.18428.29080.stgit@localhost.localdomain> <20070508055431.GA21009@localhost.localdomain> <AF0367BA48C55940A43CCF08DF35553C012AA472@az33exm24.fsl.freescale.net> <20070508202608.16c128a0@vitb.ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508202608.16c128a0@vitb.ru.mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 08:26:08PM +0400, Vitaly Bordug wrote:
> On Tue, 8 May 2007 07:29:20 -0700
> "Loeliger Jon-LOELIGER" <jdl@freescale.com> wrote:
> 
> > 
> > > > -       interrupt-controller@f8200000 {
> > > > -               linux,phandle = <f8200000>;
> > > > +		pci_pic:interrupt-controller@f8200000 {
> > > 
> > > I'd like to establish a convention of putting a space after the : and
> > > using capitals for labels unless there's a strong reason not to in a
> > > particular case.  It makes them easier to visually distinguish next to
> > > the node name.
> > 
> > Colon-space is easy and I'll buy it.
> > I'm not big on uppercase shouting, though.
> > 
> > Perhaps something more like case or goto labels:?
> > 
> >     pci_pic:
> >         interrupt-contoller@f8200000 {
> > 
> > if needed?
> > 
> I used middle solution 
> 	Pci_pic: interrupt-contoller@f8200000 {
> so first letter of the label should be uppercase.

Ick, I preferred the original lowercase.

> It makes them easily distinguishable and at the same time, not
> "shouting" manner.

I don't think it really does make them distinguishable (I'm talking
about seeing them when glancing over a screenful of dts, not just up
close).

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
