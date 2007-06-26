Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbXFZKiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbXFZKiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXFZKiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:38:05 -0400
Received: from mail.suse.de ([195.135.220.2]:45677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXFZKiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:38:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Intel IOMMU 10/10] Iommu floppy workaround
Date: Tue, 26 Jun 2007 12:37:55 +0200
User-Agent: KMail/1.9.6
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213809.110034000@askeshav-devel.jf.intel.com> <20070625234222.a1e09a16.akpm@linux-foundation.org>
In-Reply-To: <20070625234222.a1e09a16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706261237.55649.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Index: linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig
> > ===================================================================
> > --- linux-2.6.22-rc4-mm2.orig/arch/x86_64/Kconfig	2007-06-18 15:45:08.000000000 -0700
> > +++ linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig	2007-06-18 15:45:09.000000000 -0700
> > @@ -752,6 +752,16 @@
> >  	 all the OS visible memory. Hence the driver can continue
> >  	 to use physical addresses for DMA.
> >  
> > +config DMAR_FLPY_WA
> 
> FLOPPY is spelled "FLOPPY"!

Also this shouldn't be a user visible config.  The floppy driver should just
do this transparently when loaded and undo when unloaded.

Otherwise it would be a CONFIG_MAKE_MY_FLOPPY_WORK which is just not very nice.

-Andi
