Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZFOHMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZFOHMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZFOHL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:11:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:47076 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZFOHL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:11:58 -0400
Subject: Re: [PATCH][BUILD FAILURE 03/04] Next June 04:PPC64 randconfig
 [drivers/net/lance.o]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: subrata@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1245048698.5239.9.camel@subratamodak.linux.ibm.com>
References: <20090611035046.22125.26641.sendpatchset@subratamodak.linux.ibm.com>
	 <1245048698.5239.9.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 17:11:39 +1000
Message-Id: <1245049899.19217.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:21 +0530, Subrata Modak wrote:

> Benjamin,
> 
> I am not sure whether you liked the following patch to solve the above
> problem. Do, you want me address some other issue(s)/fixes for this ?

I suppose ... in fact some old PReP machines can even have ISA slots
iirc, but it's not going to do good with machines that have an iommu...

IE. Nobody should use that crap, period.

Cheers,
Ben.

Cheers,
Ben.

> Regards--
> Subrata
> 
> > 
> > --- linux-2.6.30-rc8/arch/powerpc/include/asm/io.h.orig	2009-06-10 21:56:49.000000000 -0500
> > +++ linux-2.6.30-rc8/arch/powerpc/include/asm/io.h	2009-06-10 22:21:35.000000000 -0500
> > @@ -680,6 +680,9 @@ extern void __iounmap_at(void *ea, unsig
> >  #define mmio_outsw(addr, src, count)	writesw(addr, src, count)
> >  #define mmio_outsl(addr, src, count)	writesl(addr, src, count)
> > 
> > +#define isa_virt_to_bus		virt_to_phys
> > +#define isa_bus_to_virt		phys_to_virt
> > +
> >  /**
> >   *	virt_to_phys	-	map virtual addresses to physical
> >   *	@address: address to remap
> > 
> > ---
> > Regards--
> > Subrata
> > 

