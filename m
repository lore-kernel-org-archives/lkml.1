Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYAJEUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYAJEUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 23:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbYAJEUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 23:20:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47738 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYAJEUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 23:20:45 -0500
Date: Thu, 10 Jan 2008 13:23:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-Id: <20080110132316.4f604724.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080110032631.GE15547@balbir.in.ibm.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080109134132.ba7bb33c.kamezawa.hiroyu@jp.fujitsu.com>
	<20080110022133.GC15547@balbir.in.ibm.com>
	<20080110113618.f967d215.kamezawa.hiroyu@jp.fujitsu.com>
	<20080110032631.GE15547@balbir.in.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 08:56:31 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > > The control_type feature is gone. We still have cached page
> > > accounting, but we do not allow control of only RSS pages anymore. We
> > > need to control both RSS+cached pages. I do not understand your
> > > question about new plan? Is it about adding back control_type?
> > > 
> > Ah, just wanted to confirm that we can drop PAGE_CGROUP_FLAG_CACHE
> > if page_file_cache() function and split-LRU is introduced.
> > 
> 
> Earlier we would have had a problem, since we even accounted for swap
> cache with PAGE_CGROUP_FLAG_CACHE and I think page_file_cache() does
> not account swap cache pages with page_file_cache(). Our accounting
> is based on mapped vs unmapped whereas the new code from Rik accounts
> file vs anonymous. I suspect we could live a little while longer
> with PAGE_CGROUP_FLAG_CACHE and then if we do not need it at all,
> we can mark it down for removal. What do you think?

Okay, I have no objection. 

Thanks,
-Kame

