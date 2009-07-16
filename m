Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZGPNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZGPNuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbZGPNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:50:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbZGPNuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:50:10 -0400
Message-ID: <4A5F2FDA.2060309@redhat.com>
Date: Thu, 16 Jul 2009 09:49:14 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
References: <20090716133454.GA20550@localhost>
In-Reply-To: <20090716133454.GA20550@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> global_lru_pages() / zone_lru_pages() can be used in two ways:
> - to estimate max reclaimable pages in determine_dirtyable_memory()  
> - to calculate the slab scan ratio
> 
> When swap is full or not present, the anon lru lists are not reclaimable
> and thus won't be scanned. So the anon pages shall not be counted. Also
> rename the function names to reflect the new meaning.
> 
> It can greatly (and correctly) increase the slab scan rate under high memory
> pressure (when most file pages have been reclaimed and swap is full/absent),
> thus avoid possible false OOM kills.
> 
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
