Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYAJCgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYAJCgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYAJCgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:36:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57690 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYAJCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:36:06 -0500
Date: Thu, 10 Jan 2008 11:36:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-Id: <20080110113618.f967d215.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080110022133.GC15547@balbir.in.ibm.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080109134132.ba7bb33c.kamezawa.hiroyu@jp.fujitsu.com>
	<20080110022133.GC15547@balbir.in.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 07:51:33 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > >  #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
> > >  #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
> > > +#define PAGE_CGROUP_FLAG_FILE	(0x4)	/* page is file system backed */
> > > 
> > 
> > Now, we don't have control_type and a feature for accounting only CACHE.
> > Balbir-san, do you have some new plan ?
> >
> 
> Hi, KAMEZAWA-San,
> 
> The control_type feature is gone. We still have cached page
> accounting, but we do not allow control of only RSS pages anymore. We
> need to control both RSS+cached pages. I do not understand your
> question about new plan? Is it about adding back control_type?
> 
Ah, just wanted to confirm that we can drop PAGE_CGROUP_FLAG_CACHE
if page_file_cache() function and split-LRU is introduced.


Thanks you.

-Kame

