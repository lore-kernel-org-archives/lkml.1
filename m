Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYIJK7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYIJK7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYIJK65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:58:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34364 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYIJK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:58:56 -0400
Date: Wed, 10 Sep 2008 20:03:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       hugh@veritas.com, menage@google.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct
 page
Message-Id: <20080910200304.fd078007.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200809110644.39334.nickpiggin@yahoo.com.au>
References: <48C66AF8.5070505@linux.vnet.ibm.com>
	<20080910012048.GA32752@balbir.in.ibm.com>
	<20080910104940.a7ec9b5a.kamezawa.hiroyu@jp.fujitsu.com>
	<200809110644.39334.nickpiggin@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 06:44:37 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 10 September 2008 11:49, KAMEZAWA Hiroyuki wrote:
> > On Tue, 9 Sep 2008 18:20:48 -0700
> >
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-09-09
> > > 21:30:12]: OK, here is approach #2, it works for me and gives me really
> > > good performance (surpassing even the current memory controller). I am
> > > seeing almost a 7% increase
> >
> > This number is from pre-allcation, maybe.
> > We really do alloc-at-boot all page_cgroup ? This seems a big change.
> 
> It seems really nice to me -- we get the best of both worlds, less overhead
> for those who don't enable the memory controller, and even better
> performance for those who do.

No trobles for me for allocating-all-at-boot policy.
My small concern is
  - wasting page_cgroup for hugepage area.
  - memory hotplug

> 
> Are you expecting many users to want to turn this on and off at runtime?
> I wouldn't expect so, but I don't know enough about them.
> 
There is no runtime switch. only at boot.

Thanks,
-Kame

