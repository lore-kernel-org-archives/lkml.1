Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXKLK5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXKLK5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXKLK5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:57:13 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:28198 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbXKLK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:57:12 -0500
Date: Mon, 12 Nov 2007 12:56:37 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 5/8] KVM: PVDMA: Update dma_alloc_coherent to make it paravirt-aware
Message-ID: <20071112105637.GH3299@rhun.haifa.ibm.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <e2f5f0c08d08cf66a39c8b452410078617e611f7.1194445109.git.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2f5f0c08d08cf66a39c8b452410078617e611f7.1194445109.git.amit.shah@qumranet.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 04:21:06PM +0200, Amit Shah wrote:

> Of all the DMA calls, only dma_alloc_coherent might not actually
> call dma_ops->alloc_coherent. We make sure that gets called if the
> device that's being worked on is a PV device

I always thougt that's a mess... the reason it's done this way is that
Andi Kleen preferred it for some reason at the time. How about trying
to fix it cleanly so that dma_alloc_coherent always gets called rather
than adding a hack to work around a hack? It will require auditing all
of the different x86 dma-ops but I can help with that.

Cheers,
Muli
