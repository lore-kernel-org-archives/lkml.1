Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZESGxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZESGxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZESGxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:53:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:42947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbZESGxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,213,1241420400"; 
   d="scan'208";a="144363480"
Date: Tue, 19 May 2009 14:27:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090519062757.GA9639@localhost>
References: <alpine.DEB.1.10.0905181045340.20244@qirst.com> <20090519032759.GA7608@localhost> <20090519133422.4ECC.A69D9226@jp.fujitsu.com> <20090519050932.GB8769@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519050932.GB8769@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 01:09:32PM +0800, Wu Fengguang wrote:
> On Tue, May 19, 2009 at 12:41:38PM +0800, KOSAKI Motohiro wrote:

> Note that I was creating the sparse file in btrfs, which happens to be
> very slow in sparse file reading:
> 
>         151.194384MB/s 284.198252s 100001x 450560b --load pattern-hot-10 --play /b/sparse
> 
> In that case, the inactive list is rotated at the speed of 250MB/s,
> so a full scan of which takes about 3.5 seconds, while a full scan
> of active file list takes about 77 seconds.

Hi KOSAKI: you can limit the read speed with iotrace.rb's
"--think-time" option, or to read the sparse file over network.

Thanks,
Fengguang
