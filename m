Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZLDI0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZLDI0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZLDI0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:26:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41044 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZLDI0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:26:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: more simplify shrink_inactive_list()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
Message-Id: <20091204172429.5889.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Dec 2009 17:26:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch depend on "vmscan : simplify code" patch (written by Huang Shijie)
> 
> =========================================
> Now, max_scan of shrink_inactive_list() is always passed less than
> SWAP_CLUSTER_MAX. then, we can remove scanning pages loop in it.
> 
> detail
>  - remove "while (nr_scanned < max_scan)" loop
>  - remove nr_freed variable (now, we use nr_reclaimed directly)
>  - remove nr_scan variable (now, we use nr_scanned directly)
>  - rename max_scan to nr_to_scan
>  - pass nr_to_scan into isolate_pages() directly instead
>    using SWAP_CLUSTER_MAX

Andrew, please don't pick up this patch series awhile. I and some vmscan
folks are working on fixing Larry's AIM7 problem. it is important than this
and it might makes conflict against this.

I'll rebase this patch series awhile after.



