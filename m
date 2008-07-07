Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYGGSpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYGGSpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYGGSpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:45:41 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:35685 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341AbYGGSpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:45:41 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 14:45:40 EDT
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap v2
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "lenb@kernel.org" <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <1215105012.20655.2.camel@promb-2n-dhcp368.eng.vmware.com>
References: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080625160817.GC24967@elte.hu>
	 <1214416962.27577.74.camel@promb-2n-dhcp368.eng.vmware.com>
	 <86802c440806261101k78c5057id8ca0649188bd132@mail.gmail.com>
	 <20080703125227.GA14082@elte.hu>  <20080703130035.GA23060@elte.hu>
	 <1215105012.20655.2.camel@promb-2n-dhcp368.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 07 Jul 2008 11:34:55 -0700
Message-Id: <1215455695.32752.2.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 10:10 -0700, Alok Kataria wrote:
> On Thu, 2008-07-03 at 06:00 -0700, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > > e820_search_gap also take a end_addr parameter to limit search
> > > > > from start_addr to end_addr.
> > > > >
> > > > > Signed-off-by: AloK N Kataria <akataria@vmware.com>
> > > >
> > > > Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > >
> > > applied to tip/x86/unify-setup - thanks!
> > 
> > hm, it doesnt work too well:
> > 
> >   arch/x86/pci/acpi.c: In function 'search_gap':
> >   arch/x86/pci/acpi.c:130: error: too few arguments to function 'e820_search_gap'
> > 
> > was i supposed to revert:
> > 
> > | commit 2c0262493239814b06a8aaabd1cf09b2f8fa3519
> > | Author: Alok Kataria <akataria@vmware.com>
> > | Date:   Tue Jun 24 11:48:46 2008 -0700
> > |
> > |    acpi based pci gap caluculation v2
> > 
> > ?
> 
> No...I had sent a incremental patch to the above patch..
> http://marc.info/?l=linux-kernel&m=121441818818598&w=2
> 
> Please apply this one too.
> 

Hi Ingo, 

Please let me know if you need a single patch instead of this
incremental patch. 

Thanks,
Alok

