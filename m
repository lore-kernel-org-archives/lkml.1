Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbYGTTjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbYGTTjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYGTTjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:39:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:33046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYGTTjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:39:00 -0400
Date: Sun, 20 Jul 2008 12:39:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dma_alloc_coherent() on PPC32: physical addresses above 2G
 possible?
Message-ID: <20080720123900.02677e6e@infradead.org>
In-Reply-To: <4883913F.9040706@s5r6.in-berlin.de>
References: <488385A7.4010509@s5r6.in-berlin.de>
	<20080720114358.6c88e048@infradead.org>
	<4883913F.9040706@s5r6.in-berlin.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 21:25:51 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> 
> Later on:
> 
> 	if (dev->needs_dma_mask_workaround)
> 		pci_set_consistent_dma_mask(pdev, DMA_31BIT_MASK);
> 	allocate_something_special;
> 	if (dev->needs_dma_mask_workaround)
> 		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
> 
> Or is there a variant of dma_alloc_coherent() which directly accepts a
> mask argument?

something like this.
But realistically, how many consistent/coherent allocations do you have?
some ring buffers and other one time stuff surely... but not after that?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
