Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZEPNiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZEPNiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZEPNh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:37:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbZEPNh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:37:58 -0400
Message-ID: <4A0EC197.2050806@redhat.com>
Date: Sat, 16 May 2009 09:37:27 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: [PATCH 1/3] vmscan: report vm_flags in page_referenced()
References: <20090516090005.916779788@intel.com> <20090516090448.249602749@intel.com>
In-Reply-To: <20090516090448.249602749@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
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

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
