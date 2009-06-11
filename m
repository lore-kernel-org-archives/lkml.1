Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbZFKKml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbZFKKml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761644AbZFKKme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:42:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58074 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761496AbZFKKmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:42:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH for mmotm 0/5] introduce swap-backed-file-mapped count and fix vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090611103837.GB7302@csn.ul.ie>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com> <20090611103837.GB7302@csn.ul.ie>
Message-Id: <20090611194141.6D5C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 19:42:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jun 11, 2009 at 07:25:09PM +0900, KOSAKI Motohiro wrote:
> > Recently, Wu Fengguang pointed out vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> > has underflow problem.
> > 
> 
> Can you drop this aspect of the patchset please? I'm doing a final test
> on the scan-avoidance heuristic that incorporates this patch and the
> underflow fix. Ram (the tester of the malloc()-stall) confirms the patch
> fixes his problem.

OK.
insted, I'll join to review your patch :)



> > This patch series introduce new vmstat of swap-backed-file-mapped and fix above
> > patch by it.




