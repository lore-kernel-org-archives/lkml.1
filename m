Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZIPIAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZIPIAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZIPIAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:00:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34951 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbZIPIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:00:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Sep 2009 16:58:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: memcg merge for 2.6.32 (was Re: 2.6.32 -mm merge plans)
Message-Id: <20090916165819.b8843f36.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090916073727.GP4846@balbir.in.ibm.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090916073727.GP4846@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 13:07:27 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [2009-09-15 16:15:35]:
> 
> > 
> > memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
> > memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
> > memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
> > #memcg-add-comments-explaining-memory-barriers.patch: needs update (Balbir)
> > memcg-add-comments-explaining-memory-barriers.patch
> > memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
> > memory-controller-soft-limit-documentation-v9.patch
> > memory-controller-soft-limit-interface-v9.patch
> > memory-controller-soft-limit-organize-cgroups-v9.patch
> > memory-controller-soft-limit-organize-cgroups-v9-fix.patch
> > memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
> > memcg-improve-resource-counter-scalability.patch
> > memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
> > memcg-improve-resource-counter-scalability-v5.patch
> > memcg-show-swap-usage-in-stat-file.patch
> > memcg-show-swap-usage-in-stat-file-fix.patch
> > 
> >   Merge after checking with Balbir
> 
> 
> I think these are ready for merging, I'll let Kame and Daisuke comment
> on it more.

While testing memcg, I feel that only I and Balbir and Nishimura are heavy
testers of memcg in mmotm. Because Nishimura's test is very good, I think
we could get good quality to some extent.
 
Then, I think it's time to move to -rc for getting wider testers.

But Balbir, soft-limit is a difficult thing. plz keep checking.

> The resource counter scalability patch is the most
> important patch in the series.
> 
plz don't call it as resource counter scalability patch ;)
It just skips resoruce_counter, resource_counter itself is still slow.
root-cgroup-memcg-scalability patch is good name.

I'll post other-cgroup-memcg-scalability patch series when it seems ready.
It's what I need but not for 2.6.32.

Thanks,
-Kame


