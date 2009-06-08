Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZFHOt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZFHOt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZFHOtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:49:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbZFHOtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:49:20 -0400
Message-ID: <4A2D24B0.4080301@redhat.com>
Date: Mon, 08 Jun 2009 10:48:16 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when	zone_reclaim()
 scans and fails to avoid CPU spinning at 100% on NUMA
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <4A2D129D.3020309@redhat.com> <20090608135433.GD15070@csn.ul.ie>
In-Reply-To: <20090608135433.GD15070@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Mon, Jun 08, 2009 at 09:31:09AM -0400, Rik van Riel wrote:
>> Mel Gorman wrote:
>>
>>> The scanning occurs because zone_reclaim() cannot tell
>>> in advance the scan is pointless because the counters do not distinguish
>>> between pagecache pages backed by disk and by RAM. 
>> Yes it can.  Since 2.6.27, filesystem backed and swap/ram backed
>> pages have been living on separate LRU lists. 
> 
> Yes, they're on separate LRU lists but they are not the only pages on those
> lists. The tmpfs pages are mixed in together with anonymous pages so we
> cannot use NR_*_ANON.
> 
> Look at patch 2 and where I introduced;

I have to admit I did not read patches 2 and 3 before
replying to the (strange looking, at the time) text
above patch 1.

With that logic from patch 2 in place, patch 1 makes
perfect sense.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
