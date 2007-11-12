Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXKLMAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXKLMAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXKLL7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 06:59:54 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:42869 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbXKLL7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 06:59:53 -0500
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Technologies
To: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [kvm-devel] [PATCH 5/8] KVM: PVDMA: Update dma_alloc_coherent to make it paravirt-aware
Date: Mon, 12 Nov 2007 17:29:33 +0530
User-Agent: KMail/1.9.6
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <e2f5f0c08d08cf66a39c8b452410078617e611f7.1194445109.git.amit.shah@qumranet.com> <20071112105637.GH3299@rhun.haifa.ibm.com>
In-Reply-To: <20071112105637.GH3299@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121729.33458.amit.shah@qumranet.com>
X-OriginalArrivalTime: 12 Nov 2007 11:59:52.0707 (UTC) FILETIME=[88AB4D30:01C82523]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 16:26:37 Muli Ben-Yehuda wrote:
> On Wed, Nov 07, 2007 at 04:21:06PM +0200, Amit Shah wrote:
> > Of all the DMA calls, only dma_alloc_coherent might not actually
> > call dma_ops->alloc_coherent. We make sure that gets called if the
> > device that's being worked on is a PV device
>
> I always thougt that's a mess... the reason it's done this way is that
> Andi Kleen preferred it for some reason at the time. How about trying
> to fix it cleanly so that dma_alloc_coherent always gets called rather
> than adding a hack to work around a hack? It will require auditing all
> of the different x86 dma-ops but I can help with that.

Hmm, nice to know it's like that just because of "not necessary now".

Fixing this along with stacking dma_ops and making 32-bit also dma_ops-ready 
will greatly simplify things.

>
> Cheers,
> Muli


