Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbXJOVjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbXJOVjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXJOVjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:39:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47067 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbXJOVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:39:36 -0400
Date: Mon, 15 Oct 2007 14:37:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise
 barriers)
Message-ID: <20071015143732.01d99af8@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 22:47:42 +0200 (CEST)
Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:

> > According to latest memory ordering specification documents from
> > Intel and AMD, both manufacturers are committed to in-order loads
> > from cacheable memory for the x86 architecture. Hence, smp_rmb()
> > may be a simple barrier.
> >
> > http://developer.intel.com/products/processor/manuals/318147.pdf 
> > http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf
> 
> Hi
> 
> I'm just wondering about one thing --- what is LFENCE instruction
> good for?
> 
> SFENCE is for enforcing ordering in write-combining buffers (it
> doesn't have sense in write-back cache mode).
> MFENCE is for preventing of moving stores past loads.
> 
> But what is LFENCE for? I read the above documents and they already
> say that CPUs have ordered loads.
> 

The cpus also have an explicit set of instructions that deliberately do
unordered stores/loads, and s/lfence etc are mostly designed for those.
