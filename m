Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZFIS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZFIS44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZFIS4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:56:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650AbZFIS4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:56:49 -0400
Message-ID: <4A2EB04F.2090906@redhat.com>
Date: Tue, 09 Jun 2009 14:56:15 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Count the number of times zone_reclaim() scans and
 fails
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1244566904-31470-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On NUMA machines, the administrator can configure zone_reclaim_mode that
> is a more targetted form of direct reclaim. On machines with large NUMA
> distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
> unmapped pages will be reclaimed if the zone watermarks are not being met.
> 
> There is a heuristic that determines if the scan is worthwhile but it is
> possible that the heuristic will fail and the CPU gets tied up scanning
> uselessly. Detecting the situation requires some guesswork and experimentation
> so this patch adds a counter "zreclaim_failed" to /proc/vmstat. If during
> high CPU utilisation this counter is increasing rapidly, then the resolution
> to the problem may be to set /proc/sys/vm/zone_reclaim_mode to 0.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
