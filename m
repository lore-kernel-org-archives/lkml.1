Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZEPNRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZEPNRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZEPNRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:17:11 -0400
Received: from cmpxchg.org ([85.214.51.133]:38207 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbZEPNRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:17:11 -0400
Date: Sat, 16 May 2009 15:17:02 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: [PATCH 1/3] vmscan: report vm_flags in page_referenced()
Message-ID: <20090516131702.GA5606@cmpxchg.org>
References: <20090516090005.916779788@intel.com> <20090516090448.249602749@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516090448.249602749@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 05:00:06PM +0800, Wu Fengguang wrote:
> Collect vma->vm_flags of the VMAs that actually referenced the page.
> 
> This is preparing for more informed reclaim heuristics,
> eg. to protect executable file pages more aggressively.
> For now only the VM_EXEC bit will be used by the caller.
> 
> CC: Minchan Kim <minchan.kim@gmail.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
