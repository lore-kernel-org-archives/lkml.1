Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZIPHhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZIPHhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZIPHhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:37:34 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:45618 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZIPHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:37:33 -0400
Date: Wed, 16 Sep 2009 13:07:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: memcg merge for 2.6.32 (was Re: 2.6.32 -mm merge plans)
Message-ID: <20090916073727.GP4846@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090915161535.db0a6904.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-09-15 16:15:35]:

> 
> memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
> memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
> memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
> #memcg-add-comments-explaining-memory-barriers.patch: needs update (Balbir)
> memcg-add-comments-explaining-memory-barriers.patch
> memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
> memory-controller-soft-limit-documentation-v9.patch
> memory-controller-soft-limit-interface-v9.patch
> memory-controller-soft-limit-organize-cgroups-v9.patch
> memory-controller-soft-limit-organize-cgroups-v9-fix.patch
> memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
> memory-controller-soft-limit-reclaim-on-contention-v9.patch
> memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
> memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
> memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
> memcg-improve-resource-counter-scalability.patch
> memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
> memcg-improve-resource-counter-scalability-v5.patch
> memcg-show-swap-usage-in-stat-file.patch
> memcg-show-swap-usage-in-stat-file-fix.patch
> 
>   Merge after checking with Balbir


I think these are ready for merging, I'll let Kame and Daisuke comment
on it more. The resource counter scalability patch is the most
important patch in the series.

-- 
	Balbir
