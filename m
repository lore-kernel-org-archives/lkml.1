Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZB0Ise@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZB0Ise (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZB0IsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:48:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:35074 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZB0IsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:48:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,275,1233561600"; 
   d="scan'208";a="668968249"
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: Lin Ming <ming.m.lin@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090226112232.GE32756@csn.ul.ie>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
	 <1235639427.11390.11.camel@minggr> <20090226110336.GC32756@csn.ul.ie>
	 <1235647139.16552.34.camel@penberg-laptop>
	 <20090226112232.GE32756@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 16:44:43 +0800
Message-Id: <1235724283.11610.212.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 19:22 +0800, Mel Gorman wrote: 
> In that case, Lin, could I also get the profiles for UDP-U-4K please so I
> can see how time is being spent and why it might have gotten worse?

I have done the profiling (oltp and UDP-U-4K) with and without your v2
patches applied to 2.6.29-rc6.
I also enabled CONFIG_DEBUG_INFO so you can translate address to source
line with addr2line.

You can download the oprofile data and vmlinux from below link,
http://www.filefactory.com/file/af2330b/

Lin Ming



