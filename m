Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbYGCNBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbYGCNBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYGCNBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:01:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60330 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbYGCNBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:01:00 -0400
Date: Thu, 3 Jul 2008 15:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: akataria@vmware.com, "lenb@kernel.org" <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap v2
Message-ID: <20080703130035.GA23060@elte.hu>
References: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com> <20080625160817.GC24967@elte.hu> <1214416962.27577.74.camel@promb-2n-dhcp368.eng.vmware.com> <86802c440806261101k78c5057id8ca0649188bd132@mail.gmail.com> <20080703125227.GA14082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703125227.GA14082@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > e820_search_gap also take a end_addr parameter to limit search 
> > > from start_addr to end_addr.
> > >
> > > Signed-off-by: AloK N Kataria <akataria@vmware.com>
> > 
> > Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> applied to tip/x86/unify-setup - thanks!

hm, it doesnt work too well:

  arch/x86/pci/acpi.c: In function 'search_gap':
  arch/x86/pci/acpi.c:130: error: too few arguments to function 'e820_search_gap'

was i supposed to revert:

| commit 2c0262493239814b06a8aaabd1cf09b2f8fa3519
| Author: Alok Kataria <akataria@vmware.com>
| Date:   Tue Jun 24 11:48:46 2008 -0700
|
|    acpi based pci gap caluculation v2

?

	Ingo
