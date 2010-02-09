Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0BIRE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:04:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:52851 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab0BIREy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:04:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,437,1262592000"; 
   d="scan'208";a="242159148"
Subject: Re: PROBLEM: iwlagn kernel 2.6.32.3 ooops
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "lkml@Think-Future.de" <lkml@Think-Future.de>,
       Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100209165247.GB2512@dhcp-lab-161.englab.brq.redhat.com>
References: <20100206170348.GB9411@localhost>
	 <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
	 <20100209165247.GB2512@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 09:04:52 -0800
Message-ID: <1265735092.2551.1835.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw,

On Tue, 2010-02-09 at 08:52 -0800, Stanislaw Gruszka wrote:
>  
> > > [250420.677168] Pid: 11584, comm: ip Not tainted 2.6.32.3 #5
> > > [250420.677173] Call Trace:
> > > [250420.677190]  [<c10a53f8>] ? __alloc_pages_nodemask+0x518/0x5f0
> > > [250420.677204]  [<c1007c20>] ? dma_generic_alloc_coherent+0x0/0x100
> > > [250420.677214]  [<c1007c92>] ? dma_generic_alloc_coherent+0x72/0x100
> > > [250420.677224]  [<c1007c20>] ? dma_generic_alloc_coherent+0x0/0x100
> > > [250420.677241]  [<fca1c9d5>] ? iwl_tx_queue_init+0x285/0x380 [iwlcore]
> 
> That is at initialization time. To avoid atomic allocation we can just
> use dma_alloc_coherent instead of pci_alloc_consistent. I'm going to
> prepare a patch.

I do not understand your goal here ... as seen in this trace
pci_alloc_consistent itself already calls dma_alloc_coherent right away.

Reinette


