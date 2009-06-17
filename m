Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbZFQBKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbZFQBKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZFQBJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:09:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:34504 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFQBJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:09:56 -0400
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, scottwood@freescale.com, chris.pringle@oxtel.com,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
References: <4A37DB0F.7060801@freescale.com>
	 <200906162002.12376.arnd@arndb.de> <1245197925.21602.0.camel@pasglop>
	 <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 11:07:30 +1000
Message-Id: <1245200850.21602.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 09:37 +0900, FUJITA Tomonori wrote:
> 
> dma_cache_sync is supposed to be used only with the buffers that
> dma_alloc_noncoherent() returns. On architecutures that maps
> dma_alloc_noncoherent to dma_alloc_coherent, dma_cache_sync() is
> supposed to be NOP.
> 
Or at least a sync() on powerpc but yeah, I see. We should probably do
that.

Cheers,
Ben.


