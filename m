Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZFOHWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZFOHWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZFOHVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:21:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47240 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZFOHVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:21:53 -0400
Subject: Re: [PATCH][BUILD FAILURE 03/04] Next June 04:PPC64 randconfig
	[drivers/net/lance.o]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1245049899.19217.56.camel@pasglop>
References: <20090611035046.22125.26641.sendpatchset@subratamodak.linux.ibm.com>
	 <1245048698.5239.9.camel@subratamodak.linux.ibm.com>
	 <1245049899.19217.56.camel@pasglop>
Content-Type: text/plain
Organization: IBM
Date: Mon, 15 Jun 2009 12:51:49 +0530
Message-Id: <1245050509.5239.11.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 17:11 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-15 at 12:21 +0530, Subrata Modak wrote:
> 
> > Benjamin,
> > 
> > I am not sure whether you liked the following patch to solve the above
> > problem. Do, you want me address some other issue(s)/fixes for this ?
> 
> I suppose ... in fact some old PReP machines can even have ISA slots
> iirc, but it's not going to do good with machines that have an iommu...
> 
> IE. Nobody should use that crap, period.

Great,

Can you please make some changes at drivers/net/Kconfig so that this guy
does not build for the PPC64 systems ?

Regards--
Subrata

> 
> Cheers,
> Ben.
> 
> Cheers,
> Ben.
> 
> > Regards--
> > Subrata
> > 
> > > 
> > > --- linux-2.6.30-rc8/arch/powerpc/include/asm/io.h.orig	2009-06-10 21:56:49.000000000 -0500
> > > +++ linux-2.6.30-rc8/arch/powerpc/include/asm/io.h	2009-06-10 22:21:35.000000000 -0500
> > > @@ -680,6 +680,9 @@ extern void __iounmap_at(void *ea, unsig
> > >  #define mmio_outsw(addr, src, count)	writesw(addr, src, count)
> > >  #define mmio_outsl(addr, src, count)	writesl(addr, src, count)
> > > 
> > > +#define isa_virt_to_bus		virt_to_phys
> > > +#define isa_bus_to_virt		phys_to_virt
> > > +
> > >  /**
> > >   *	virt_to_phys	-	map virtual addresses to physical
> > >   *	@address: address to remap
> > > 
> > > ---
> > > Regards--
> > > Subrata
> > > 
> 

