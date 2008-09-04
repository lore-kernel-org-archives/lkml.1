Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYIDI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYIDI3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbYIDI2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:28:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbYIDI2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:28:13 -0400
Date: Thu, 4 Sep 2008 10:31:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, joerg.roedel@amd.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       tony.luck@intel.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures with swiotlb
Message-ID: <20080904083124.GA18288@one.firstfloor.org>
References: <20080904074441.GY18288@one.firstfloor.org> <20080904165852I.fujita.tomonori@lab.ntt.co.jp> <20080904080528.GZ18288@one.firstfloor.org> <20080904171903M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904171903M.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even if it's tree, only each IOMMU knows what's the best. That's the
> point of these changes to remove the tricks in arch/x86/pci-dma.c and
> let IOMMUs do what they want.

Duplicating all the code.  Sounds great.
 
> > Also there's usually the problem that not all busses are translated,
> > e.g. Calgary used to do that so for e.g. dev == NULL allocations you had
> > to use  these fallback algorithms anyways.
> 
> dev == NULL isn't a minor thing. It's just using the fallback
> device.

You still have to handle it fully.

-Andi
