Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbXKLKvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbXKLKvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXKLKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:51:10 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:53402 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbXKLKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:51:08 -0500
Date: Mon, 12 Nov 2007 12:50:01 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] KVM: PVDMA Guest: Guest-side routines for paravirtualized DMA
Message-ID: <20071112105001.GF3299@rhun.haifa.ibm.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <609d5d611a5fb58ab5a7184be7b6d29494023ba0.1194445109.git.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <609d5d611a5fb58ab5a7184be7b6d29494023ba0.1194445109.git.amit.shah@qumranet.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 04:21:04PM +0200, Amit Shah wrote:

> We make the dma_mapping_ops structure to point to our structure so
> that every DMA access goes through us. (This is the reason this only
> works for 64-bit guest. 32-bit guest doesn't yet have a dma_ops
> struct.)

I need the same facility for Calgary for falling back to swiotlb if a
translation is disabled on some slot, and IB needs the same facility
for some IB adapters (e.g., ipath). Perhaps it's time to consider
stackable dma-ops (unless someone has a better idea...).

Cheers,
Muli
