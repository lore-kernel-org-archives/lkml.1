Return-Path: <linux-kernel-owner+w=401wt.eu-S934442AbXJPSox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442AbXJPSox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbXJPSom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:44:42 -0400
Received: from ns.suse.de ([195.135.220.2]:35232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464AbXJPSom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:44:42 -0400
Date: Tue, 16 Oct 2007 20:44:40 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
Message-ID: <20071016184440.GA19844@suse.de>
Mail-Followup-To: Dave Hansen <haveblue@us.ibm.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	akpm@linux-foundation.org, ak@suse.de
References: <20071016162857.635479952@strauss.suse.de> <20071016162858.545617122@strauss.suse.de> <1192558097.17464.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192558097.17464.15.camel@localhost>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Dave Hansen <haveblue@us.ibm.com> [2007-10-16 20:08]:
> On Tue, 2007-10-16 at 18:28 +0200, Bernhard Walle wrote:
> > 
> > @@ -736,7 +736,7 @@ static int __init smp_scan_config (unsig
> >                         smp_found_config = 1;
> >                         printk(KERN_INFO "found SMP MP-table at %08lx\n",
> >                                                 virt_to_phys(mpf));
> > -                       reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE);
> > +                       reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE, 0);
> >                         if (mpf->mpf_physptr) {
> >                                 /* 
> 
> Could you give all of these 0's a name?  I really hate seeing random
> magic numbers in these things.  0 completely kills the ability of
> someone to read the code and figure out what it is trying to do without
> going and looking at reserve_bootmem().

Of course I can replace that zeroes with something like BOOTMEM_DEFAULT.

> Or, alternatively, do something like this:
> 
> -extern void reserve_bootmem(unsigned long addr, unsigned long size);

Andi was against more bootmem functions. ;)


Thanks,
   Bernhard
