Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZENUXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZENUXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZENUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:23:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZENUX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:23:26 -0400
Message-ID: <4A0C7DB6.6010601@redhat.com>
Date: Thu, 14 May 2009 16:23:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Robin Holt <holt@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120729.5885.A69D9226@jp.fujitsu.com> <20090513152256.GM7601@sgi.com> <alpine.DEB.1.10.0905141602010.1381@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0905141602010.1381@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Not having zone reclaim on a NUMA system often means that per node
> allocations will fall back. Optimized node local allocations become very
> difficult for the page allocator. If the latency penalties are not
> significant then this may not matter. The larger the system, the larger
> the NUMA latencies become.
> 
> One possibility would be to disable zone reclaim for low node numbers.
> Eanble it only if more than 4 nodes exist?

I suspect that patches 1/4 through 3/4 will cause the
system to behave better already, by only reclaiming
the easiest to reclaim pages from zone reclaim and
falling back after that - or am overlooking something?
