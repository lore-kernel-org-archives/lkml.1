Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZL2OKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZL2OKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZL2OKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:10:54 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39204 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZL2OKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:10:53 -0500
Date: Tue, 29 Dec 2009 19:39:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] memcg: add anon_scan_ratio to memory.stat file
Message-ID: <20091229140957.GR3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
 <20091228164857.A690.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091228164857.A690.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-12-28 16:49:27]:

> anon_scan_ratio feature doesn't only useful for global VM pressure
> analysis, but it also useful for memcg memroy pressure analysis.
> 
> Then, this patch add anon_scan_ratio field to memory.stat file too.
> 
> Instead, following debug statistics was removed. It isn't so user and/or
> developer friendly.
> 
> 	- recent_rotated_anon
> 	- recent_rotated_file
> 	- recent_scanned_anon
> 	- recent_scanned_file
>

I've been using these to look at statistics - specifically reclaim
data on my developer kernels.
 
-- 
	Balbir
