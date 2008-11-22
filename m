Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYKVKRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYKVKRK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 05:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYKVKQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 05:16:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:49500 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbYKVKQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 05:16:51 -0500
Date: Sat, 22 Nov 2008 19:16:05 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       netdev@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/10] x86: add initialization code for DMA-API
 debugging
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081122094032.GJ29705@8bytes.org>
References: <1227284770-19215-4-git-send-email-joerg.roedel@amd.com>
	<20081122120058I.fujita.tomonori@lab.ntt.co.jp>
	<20081122094032.GJ29705@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081122191533K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 10:40:32 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> > > +static int hash_fn(struct dma_debug_entry *entry)
> > > +{
> > > +	/*
> > > +	 * Hash function is based on the dma address.
> > > +	 * We use bits 20-27 here as the index into the hash
> > > +	 */
> > > +	BUG_ON(entry->dev_addr == bad_dma_address);
> > 
> > 'bad_dma_address' is x86 specific. You already found it though.
> 
> Interesting. Is there another value for dma_addr_t which drivers can
> check for to find out if a dma-api operation failed?

They are architecture dependent. But only X86 uses a variable because
of GART and swiotlb, I think.
