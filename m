Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbXEOS7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbXEOS7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXEOS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:59:46 -0400
Received: from holomorphy.com ([66.93.40.71]:39969 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbXEOS7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:59:46 -0400
Date: Tue, 15 May 2007 11:59:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: don't check_pgt_cache in flush_tlb_mm
Message-ID: <20070515185947.GY19966@holomorphy.com>
References: <Pine.LNX.4.64.0705151946550.30826@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705151946550.30826@blonde.wat.veritas.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 07:51:05PM +0100, Hugh Dickins wrote:
> No other architecture calls check_pgt_cache() from within flush_tlb_mm(),
> and i386 is already calling check_pgt_cache() from the usual places,
> tlb_finish_mmu() and cpu_idle() (the latter being odd, but not unusual).
> flush_tlb_mm() has no business to be freeing pages: remove that line,
> which sneaked in with slub's i386 support.
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
