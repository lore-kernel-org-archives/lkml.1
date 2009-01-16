Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZAPHCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZAPHCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZAPHBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:01:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbZAPHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:01:47 -0500
Date: Thu, 15 Jan 2009 23:00:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: netdev@vger.kernel.org, sfr@canb.auug.org.au, matthew@wil.cx,
       matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
Subject: Re: Mainline kernel OLTP performance update
Message-Id: <20090115230043.57caae5d.akpm@linux-foundation.org>
In-Reply-To: <200901161746.25205.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	<200901161503.13730.nickpiggin@yahoo.com.au>
	<20090115201210.ca1a9542.akpm@linux-foundation.org>
	<200901161746.25205.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 17:46:23 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 16 January 2009 15:12:10 Andrew Morton wrote:
> > On Fri, 16 Jan 2009 15:03:12 +1100 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > I would like to see SLQB merged in mainline, made default, and wait for
> > > some number releases. Then we take what we know, and try to make an
> > > informed decision about the best one to take. I guess that is problematic
> > > in that the rest of the kernel is moving underneath us. Do you have
> > > another idea?
> >
> > Nope.  If it doesn't work out, we can remove it again I guess.
> 
> OK, I have these numbers to show I'm not completely off my rocker to suggest
> we merge SLQB :) Given these results, how about I ask to merge SLQB as default
> in linux-next, then if nothing catastrophic happens, merge it upstream in the
> next merge window, then a couple of releases after that, given some time to
> test and tweak SLQB, then we plan to bite the bullet and emerge with just one
> main slab allocator (plus SLOB).

That's a plan.

> SLQB tends to be the winner here.

Can you think of anything with which it will be the loser?

