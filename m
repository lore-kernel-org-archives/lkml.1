Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbZJGHdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbZJGHdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZJGHda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:33:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146AbZJGHda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:33:30 -0400
Date: Wed, 7 Oct 2009 00:32:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, peterz@infradead.org, paulus@samba.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Provide vmalloc() based mmap() backing
Message-Id: <20091007003202.5a8ac565.akpm@linux-foundation.org>
In-Reply-To: <20091007.001321.197898334.davem@davemloft.net>
References: <1254830228.21044.272.camel@laptop>
	<20091006122359.GA7614@elte.hu>
	<20091007.001321.197898334.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 00:13:21 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 6 Oct 2009 14:23:59 +0200
> 
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> >> OK, so I rewrote it a few more times, does the below make everybody 
> >> feel warm and fuzzy?
> > 
> > Yeah, looks perfect to me - applied to tip:perf/urgent, thanks Peter!
> > 
> > Dave, could you please test it on Sparc too? The Git coordinates are at:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/urgent
> 
> Works fine here, I forced the vmalloc stuff on using the debug
> option.  Once your stuff goes in I'll add the select statement
> to arch/sparc/Kconfig
> 
> Andrew also needs to marge the vmalloc_user() patch.  I almost
> forgot that to apply to my tree when testing :-)

I seem to have lost it.  We might as well keep the two patches together
so can you please handle it?

