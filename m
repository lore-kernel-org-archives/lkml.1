Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZEIKU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZEIKU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZEIKUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:20:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36439 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZEIKUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:20:12 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class citizen
Cc: kosaki.motohiro@jp.fujitsu.com, Elladan <elladan@eskimo.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.1.10.0905081312080.15748@qirst.com>
References: <20090508034054.GB1202@eskimo.com> <alpine.DEB.1.10.0905081312080.15748@qirst.com>
Message-Id: <20090509191818.3AD8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat,  9 May 2009 19:20:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 7 May 2009, Elladan wrote:
> 
> > > Nobody (except you) is proposing that we completely disable
> > > the eviction of executable pages.  I believe that your idea
> > > could easily lead to a denial of service attack, with a user
> > > creating a very large executable file and mmaping it.
> 
> The amount of mlockable pages is limited via ulimit. We can already make
> the pages unreclaimable through mlock().
> 
> > I don't know of any distro that applies default ulimits, so desktops are
> > already susceptible to the far more trivial "call malloc a lot" or "fork bomb"
> > attacks.  Plus, ulimits don't help, since they only apply per process - you'd
> > need a default mem cgroup before this mattered, I think.
> 
> The point remains that the proposed patch does not solve the general
> problem that we encounter with exec pages of critical components of the
> user interface being evicted from memory.
> 
> Do we have test data that shows a benefit? The description is minimal. Rik
> claimed on IRC that tests have been done. If so then the patch description
> should include the tests. Which loads benefit from this patch?
> 
> A significant change to the reclaim algorithm also needs to
> have a clear description of the effects on reclaim behavior which is also
> lacking.

btw,

This is very good news to me.
Recently I've taked sevaral time for reproducing this issue. but
I have no luck. I'm interesting its test-case.

Thanks.


