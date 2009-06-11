Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZFKKip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZFKKip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761329AbZFKKii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:38:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56451 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbZFKKih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:38:37 -0400
Date: Thu, 11 Jun 2009 11:38:37 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for mmotm 0/5] introduce swap-backed-file-mapped count
	and fix
	vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
Message-ID: <20090611103837.GB7302@csn.ul.ie>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:25:09PM +0900, KOSAKI Motohiro wrote:
> Recently, Wu Fengguang pointed out vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> has underflow problem.
> 

Can you drop this aspect of the patchset please? I'm doing a final test
on the scan-avoidance heuristic that incorporates this patch and the
underflow fix. Ram (the tester of the malloc()-stall) confirms the patch
fixes his problem.

> This patch series introduce new vmstat of swap-backed-file-mapped and fix above
> patch by it.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
