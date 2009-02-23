Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZBWJK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZBWJK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZBWJKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:10:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50986 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZBWJKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:10:41 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
In-Reply-To: <84144f020902222329u5754f8b1k790809191ac48f4a@mail.gmail.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <84144f020902222329u5754f8b1k790809191ac48f4a@mail.gmail.com>
Message-Id: <20090223180906.47F1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Feb 2009 18:10:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > The complexity of the page allocator has been increasing for some time
> > and it has now reached the point where the SLUB allocator is doing strange
> > tricks to avoid the page allocator. This is obviously bad as it may encourage
> > other subsystems to try avoiding the page allocator as well.
> 
> I'm not an expert on the page allocator but the series looks sane to me.

Yeah!
I also strongly like this patch series.

Unfortunately, I don't have enough time for patch review in this week.
but I expect I can review and test it next week.

thanks.


> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Yanmin, it would be interesting to know if we still need 8K kmalloc
> caches with these patches applied. :-)
> 
>                                Pekka



