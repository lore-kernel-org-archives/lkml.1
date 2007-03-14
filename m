Return-Path: <linux-kernel-owner+w=401wt.eu-S1161041AbXCNUq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041AbXCNUq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161062AbXCNUq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:46:28 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:53426 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161041AbXCNUq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:46:27 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Date: Wed, 14 Mar 2007 14:46:16 -0600
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703141236.09599.bjorn.helgaas@hp.com> <Pine.LNX.4.64.0703141855010.18468@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0703141855010.18468@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703141446.16274.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 12:59, Mel Gorman wrote:
> > <SNIP>
> > Virtual mem_map starts at 0xa0007fffc7200000
> > Zone PFN ranges:
> 
> Total aside, a message should have been printed out here with 
> "sizeof(struct page) = ??" when loglevel was set to 8. I wanted it so I 
> could work out PFNs from the faulting addresses. Can you find such a 
> string in the output of dmesg?

You probably don't need this anymore, but sizeof(struct page) = 56.

> > BUG: at drivers/pci/pci.c:679 pci_restore_state()
> >
> > Call Trace:
> > [<a000000100014980>] show_stack+0x40/0xa0
> >                                sp=e000004063a5fb90 bsp=e000004063a58f98
> > [<a0000001000152b0>] dump_stack+0x30/0x60
> >                                sp=e000004063a5fd60 bsp=e000004063a58f80
> > [<a0000001003f8800>] pci_restore_state+0x480/0x4a0
> >                                sp=e000004063a5fd60 bsp=e000004063a58f38
> > [<a00000010051a0b0>] tg3_chip_reset+0x6d0/0x1020
> ...
> That doesn't look particularly healthy! Is this a known problem?

Yeah, that's ugly, isn't it?  I hadn't got to worrying about that yet.
