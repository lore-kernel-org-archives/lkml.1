Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYJCGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYJCGso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYJCGsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:48:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38012 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYJCGsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:48:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/4] Reclaim page capture v4
Cc: kosaki.motohiro@jp.fujitsu.com, "Andy Whitcroft" <apw@shadowen.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, "Mel Gorman" <mel@csn.ul.ie>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <28c262360810011946p443350d3hcb271720892e7b85@mail.gmail.com>
References: <1222864261-22570-1-git-send-email-apw@shadowen.org> <28c262360810011946p443350d3hcb271720892e7b85@mail.gmail.com>
Message-Id: <20081003154616.EF74.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  3 Oct 2008 15:48:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Andy.
> 
> I tested your patch in my desktop.
> The test is just kernel compile with single thread.
> My system environment is as follows.
> 
> model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
> MemTotal:        2065856 kB
> 
> When I tested vanilla, compile time is as follows.
> 
> 2433.53user 187.96system 42:05.99elapsed 103%CPU (0avgtext+0avgdata
> 0maxresident)k
> 588752inputs+4503408outputs (127major+55456246minor)pagefaults 0swaps
> 
> When I tested your patch, as follows.
> 
> 2489.63user 202.41system 44:47.71elapsed 100%CPU (0avgtext+0avgdata
> 0maxresident)k
> 538608inputs+4503928outputs (130major+55531561minor)pagefaults 0swaps
> 
> Regresstion almost is above 2 minutes.
> Do you think It is a trivial?

Ooops.
this is definitly significant regression.


> I know your patch is good to allocate hugepage.
> But, I think many users don't need it, including embedded system and
> desktop users yet.
> 
> So I suggest you made it enable optionally.

No.
if the patch has this significant regression,
nobody turn on its option.

We should fix that.


