Return-Path: <linux-kernel-owner+w=401wt.eu-S2992760AbXDRVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992760AbXDRVXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992762AbXDRVXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:23:10 -0400
Received: from holomorphy.com ([66.93.40.71]:37888 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992760AbXDRVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:23:09 -0400
Date: Wed, 18 Apr 2007 14:23:27 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix OOM killing processes wrongly thought MPOL_BIND
Message-ID: <20070418212327.GT2986@holomorphy.com>
References: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704182022440.11100@blonde.wat.veritas.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 08:35:22PM +0100, Hugh Dickins wrote:
> I only have CONFIG_NUMA=y for build testing: surprised when trying a memhog
> to see lots of other processes killed with "No available memory (MPOL_BIND)".
> memhog is killed correctly once we initialize nodemask in constrained_alloc().
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Perhaps appropriate for 2.6.20-stable too - regression since 2.6.19.

This is a clear fix for an uninitialized variable.


Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
