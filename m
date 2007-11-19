Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXKSM66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXKSM66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXKSM6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:58:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57511 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbXKSM6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:58:50 -0500
Date: Mon, 19 Nov 2007 12:58:43 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 16/30] cpu alloc: XFS counters
Message-ID: <20071119125843.GE15942@infradead.org>
References: <20071116230920.278761667@sgi.com> <20071116231105.937156196@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116231105.937156196@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 03:09:36PM -0800, Christoph Lameter wrote:
>  	cntp = (xfs_icsb_cnts_t *)
> -			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
> +			CPU_PTR(mp->m_sb_cnts, (unsigned long)hcpu);
> -	mp->m_sb_cnts = alloc_percpu(xfs_icsb_cnts_t);
> +	mp->m_sb_cnts = CPU_ALLOC(xfs_icsb_cnts_t, GFP_KERNEL | __GFP_ZERO);

What's the point for renaming these?  And even if you have a case for
renamining them please give them proper lower-case names.

