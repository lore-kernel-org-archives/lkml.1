Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZESIGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZESIGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZESIGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:06:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37314 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbZESIGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:06:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class citizen
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090519074925.GA690@localhost>
References: <20090519161756.4EE4.A69D9226@jp.fujitsu.com> <20090519074925.GA690@localhost>
Message-Id: <20090519170208.742C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 17:06:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Like the console mode, the absolute nr_mapped drops considerably - to 1/13 of
> > > the original size - during the streaming IO.
> > > 
> > > The delta of pgmajfault is 3 vs 107 during IO, or 236 vs 393 during the whole
> > > process.
> > 
> > hmmm.
> > 
> > about 100 page fault don't match Elladan's problem, I think.
> > perhaps We missed any addional reproduce condition?
> 
> Elladan's case is not the point of this test.
> Elladan's IO is use-once, so probably not a caching problem at all.
> 
> This test case is specifically devised to confirm whether this patch
> works as expected. Conclusion: it is.

Dejection ;-)

The number should address the patch is useful or not. confirming as expected
is not so great.
I don't think your patch is strange, but I really want to find reproduce way.



