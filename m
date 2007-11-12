Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXKLL5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXKLL5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 06:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbXKLL44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 06:56:56 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:41827 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757255AbXKLL44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 06:56:56 -0500
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Technologies
To: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [kvm-devel] [PATCH 3/8] KVM: PVDMA Guest: Guest-side routines for paravirtualized DMA
Date: Mon, 12 Nov 2007 17:26:24 +0530
User-Agent: KMail/1.9.6
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <609d5d611a5fb58ab5a7184be7b6d29494023ba0.1194445109.git.amit.shah@qumranet.com> <20071112105001.GF3299@rhun.haifa.ibm.com>
In-Reply-To: <20071112105001.GF3299@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121726.24907.amit.shah@qumranet.com>
X-OriginalArrivalTime: 12 Nov 2007 11:56:53.0047 (UTC) FILETIME=[1D955C70:01C82523]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 16:20:01 Muli Ben-Yehuda wrote:
> On Wed, Nov 07, 2007 at 04:21:04PM +0200, Amit Shah wrote:
> > We make the dma_mapping_ops structure to point to our structure so
> > that every DMA access goes through us. (This is the reason this only
> > works for 64-bit guest. 32-bit guest doesn't yet have a dma_ops
> > struct.)
>
> I need the same facility for Calgary for falling back to swiotlb if a
> translation is disabled on some slot, and IB needs the same facility
> for some IB adapters (e.g., ipath). Perhaps it's time to consider
> stackable dma-ops (unless someone has a better idea...).

That would make great sense and simplify implementations.

How do you propose such an implementation? An array of function pointers for 
each possible call?

>
> Cheers,
> Muli

Amit.
