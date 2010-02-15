Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0BOB6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 20:58:20 -0500
Received: from sh.osrg.net ([192.16.179.4]:60330 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0BOB6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 20:58:18 -0500
Date: Mon, 15 Feb 2010 10:57:58 +0900
To: benh@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm 5/7] powerpc: use generic pci_set_dma_mask and
 pci_set_consistent_dma_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1266190600.16346.74.camel@pasglop>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265967212-9126-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1266190600.16346.74.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100215105606Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 15 Feb 2010 10:57:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 10:36:40 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2010-02-12 at 18:33 +0900, FUJITA Tomonori wrote:
> > This converts powerpc to use the generic pci_set_dma_mask and
> > pci_set_consistent_dma_mask (drivers/pci/pci.c).
> > 
> > The generic pci_set_dma_mask does what powerpc's pci_set_dma_mask
> > does.
> > 
> > Unlike powerpc's pci_set_consistent_dma_mask, the gneric
> > pci_set_consistent_dma_mask sets only coherent_dma_mask. It doesn't
> > work for powerpc? pci_set_consistent_dma_mask API should set only
> > coherent_dma_mask?
> 
> I don't know why we do it that way, your patch looks correct to me, if
> we have a driver bug assuming it does both masks at once, then we'll
> fix it.
> 
> Do you need me to merge that via powerpc.git or are you happy to carry
> it with the rest of your PCI DMA changes ?

I guess it's easier if Andrew carries all the patches since some of
the patches in this patchset depend on my other patches in -mm.


> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks!
