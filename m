Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYIIHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYIIHma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYIIHmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:42:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39362 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYIIHmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:42:21 -0400
Date: Tue, 9 Sep 2008 16:37:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Message-Id: <20080909163721.76a2249d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48C5F91D.5070500@linux.vnet.ibm.com>
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
	<200809011743.42658.nickpiggin@yahoo.com.au>
	<48BD0641.4040705@linux.vnet.ibm.com>
	<20080902190256.1375f593.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD0E4A.5040502@linux.vnet.ibm.com>
	<20080902190723.841841f0.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD119B.8020605@linux.vnet.ibm.com>
	<20080902195717.224b0822.kamezawa.hiroyu@jp.fujitsu.com>
	<48BD337E.40001@linux.vnet.ibm.com>
	<20080903123306.316beb9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20080908152810.GA12065@balbir.in.ibm.com>
	<20080909125751.37042345.kamezawa.hiroyu@jp.fujitsu.com>
	<48C5F91D.5070500@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 21:18:37 -0700
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Mon, 8 Sep 2008 20:58:10 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >> Sorry for the delay in sending out the new patch, I am traveling and
> >> thus a little less responsive. Here is the update patch
> >>
> >>
> > Hmm.. I've considered this approach for a while and my answer is that
> > this is not what you really want.
> > 
> > Because you just moves the placement of pointer from memmap to
> > radix_tree both in GFP_KERNEL, total kernel memory usage is not changed.
> 
> Agreed, but we do reduce the sizeof(struct page) without adding on to
> page_cgroup's size. So why don't we want this?
> 
Because it's depends on CONFIG.

But ok, I'll recall my patches from grave. Maybe it can be a hint for you.

Thanks,
-Kame

