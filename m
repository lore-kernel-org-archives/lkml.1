Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbXFEVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbXFEVA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXFEU7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:59:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:9707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780AbXFEU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,386,1175497200"; 
   d="scan'208";a="251174329"
Date: Tue, 5 Jun 2007 13:48:03 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routines for handling pre-allocated pool of objects
Message-ID: <20070605204802.GB27638@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.156875000@askeshav-devel.jf.intel.com> <20070604225714.GM20299@havoc.gtf.org> <20070604230649.GB9948@linux-os.sc.intel.com> <20070604234354.GC31462@havoc.gtf.org> <20070604235105.GA13390@linux-os.sc.intel.com> <20070605202433.GA27638@linux-os.sc.intel.com> <20070605203048.GR31565@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605203048.GR31565@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:30:48PM -0400, Jeff Garzik wrote:
> On Tue, Jun 05, 2007 at 01:24:33PM -0700, Keshavamurthy, Anil S wrote:
> >  1 file changed, 65 insertions(+), 19 deletions(-)
> > 
> > Index: linux-2.6.22-rc3/lib/respool.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/lib/respool.c	2007-06-05 12:22:26.000000000 -0700
> > +++ linux-2.6.22-rc3/lib/respool.c	2007-06-05 12:58:01.000000000 -0700
> > @@ -67,6 +67,7 @@
> >  {
> >  	unsigned long	flags;
> >  	struct list_head *plist = (struct list_head *)vaddr;
> > +	bool queue_work = 0;
> 
> Seems sane to me.
Thanks so much.

> 
> I only have a very minor nit to pick:  naming a variable (queue_work)
> the same as a public function may cause confusion.
> 
> Also, if its a bool you should initialize it to 'true' or 'false'.
I will address when this patch gets into Andrew's mm tree.

Thanks once again,
Anil

