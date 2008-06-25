Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYFYOX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYFYOX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbYFYOXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:23:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56825 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757545AbYFYOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:23:03 -0400
Date: Wed, 25 Jun 2008 10:23:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: andi@firstfloor.org, <linux-kernel@vger.kernel.org>,
       <antonio.lin@alcormicro.com>, <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <20080625091813Z.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.0806251017320.2578-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, FUJITA Tomonori wrote:

> > For example, suppose an I/O request starts out with two S-G elements
> > of 1536 bytes and 2048 bytes respectively, and the DMA requirement is
> > that all elements except the last must have length divisible by 1024.  
> > Then the request could be broken up into three requests of 1024, 512,
> > and 2048 bytes.
> 
> I can't say that it's easy to implement a clean mechanism to break up
> a request into multiple requests until I see a patch.

And I can't write a patch without learning a lot more about how the
block core works.

> What I said is that you think that this is about extending something
> in the block layer but it's about adding a new concept to the block
> layer.

Is it?  What does the block layer do when it receives an I/O request
that don't satisfy the other constraints (max_sectors or
dma_alignment_mask, for example)?

> > Is it reasonable to have 120-KB bounce buffers?
> 
> The block layer does. Why do you think that USB can't?

Why do you think I think that USB can't?  I didn't ask whether it was
_possible_; I asked whether it was _reasonable_.

Alan Stern

