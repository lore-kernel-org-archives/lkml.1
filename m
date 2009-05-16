Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZEPOgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZEPOgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZEPOgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:36:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44080 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZEPOgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:36:08 -0400
Message-ID: <4A0ECF1C.4010700@redhat.com>
Date: Sat, 16 May 2009 10:35:08 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] vmscan: merge duplicate code in shrink_active_list()
References: <20090516090005.916779788@intel.com> <20090516090448.535217680@intel.com>
In-Reply-To: <20090516090448.535217680@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> The "move pages to active list" and "move pages to inactive list"
> code blocks are mostly identical and can be served by a function.
> 
> Thanks to Andrew Morton for pointing this out.
> 
> Note that buffer_heads_over_limit check will also be carried out
> for re-activated pages, which is slightly different from pre-2.6.28
> kernels. Also, Rik's "vmscan: evict use-once pages first" patch
> could totally stop scans of active list when memory pressure is low.
> So the net effect could be, the number of buffer heads is now more
> likely to grow large.
> 
> CC: Rik van Riel <riel@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
