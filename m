Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZFVJh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZFVJh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZFVJhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:37:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:2871 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZFVJhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,267,1243839600"; 
   d="scan'208";a="157059602"
Date: Mon, 22 Jun 2009 17:37:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Minchan Kim <minchan.kim@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 11/15] HWPOISON: The high level memory error handler in
	the VM v8
Message-ID: <20090622093725.GB11541@localhost>
References: <20090620031608.624240019@intel.com> <20090620031626.106150781@intel.com> <20090621085721.GD8218@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090621085721.GD8218@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 04:57:21PM +0800, Andi Kleen wrote:
> > v8:
> > check for page_mapped_in_vma() on anon pages (Hugh, Fengguang)
> 
> This change was no good as discussed earlier.

My understanding is, we don't do page_mapped_in_vma() for file pages.
But for anon pages, this check can avoid killing possibly good tasks.

Thanks,
Fengguang
