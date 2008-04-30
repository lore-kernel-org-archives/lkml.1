Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbYD3G1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbYD3G1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYD3G1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:27:14 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:52100 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYD3G1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:27:13 -0400
Date: Wed, 30 Apr 2008 09:29:41 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, virtualization@lists.linux-foundation.org,
       Ben-Ami Yassour1 <BENAMI@il.ibm.com>, gcosta@redhat.com,
       chrisw@redhat.com, dor.laor@qumranet.com, allen.m.kay@intel.com,
       avi@qumranet.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 DMA: Handle devices assigned to the guest by the
	host
Message-ID: <20080430062940.GM7378@il.ibm.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:37:29PM +0300, Amit Shah wrote:

> dma_alloc_coherent() doesn't call dma_ops->alloc_coherent in case no
> IOMMU translations are necessary.

I always thought this was a huge wart in the x86-64 DMA ops. Would
there be strong resistance to fixing it so that alloc_coherent
matches the way the other ops are used? This will eliminate the need
for this patch and will make other DMA ops implementations saner.

Cheers,
Muli
