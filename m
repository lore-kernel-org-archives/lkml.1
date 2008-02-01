Return-Path: <linux-kernel-owner+w=401wt.eu-S1765437AbYBACiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765437AbYBACiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYBACiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:38:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46743 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446AbYBACiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:38:17 -0500
Date: Thu, 31 Jan 2008 20:38:15 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: mmu_notifier: invalidate_range for move_page_tables
Message-ID: <20080201023815.GC26420@sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com> <20080131123118.GK7185@v2.random> <Pine.LNX.4.64.0801311355260.27804@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0801311421110.22290@schroedinger.engr.sgi.com> <20080201001355.GU7185@v2.random> <Pine.LNX.4.64.0801311752200.24427@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311752200.24427@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:57:25PM -0800, Christoph Lameter wrote:
> Move page tables also needs to invalidate the external references
> and hold new references off while moving page table entries.

I must admit to not having spent any time thinking about this, but aren't
we moving the entries from one set of page tables to the other, leaving
the pte_t entries unchanged.  I guess I should go look, but could you
provide a quick pointer in the proper direction as to why we need to
recall externals when the before and after look of these page tables
will have the same information for the TLBs.

Thanks,
Robin
