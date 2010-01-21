Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347Ab0AUDMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0AUDMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591Ab0AUDMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:12:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56098 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0AUDMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:12:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC-PATCH 0/7] Memory Compaction v1
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie>
Message-Id: <20100121115636.73BA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 Jan 2010 12:12:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Sorry, I haven't read this patch at all.

> The time differences are marginal but bear in mind that this is an ideal
> case of mostly unmapped buffer pages. On nice set of results is between
> allocations 13-18 where no pages were reclaimed, some compaction occured
> and 300 huge pages were allocated in 0.16 seconds. Furthermore, compaction
> allocated a high higher percentage of memory (91% of RAM as huge pages).
> 
> The downside appears to be that the compaction kernel reclaimed even more
> pages than the vanilla kernel. However, take the cut-off point of 880 pages
> that both kernels succeeded. The vanilla kernel had reclaimed 105132 pages
> at that point. The kernel with compaction had reclaimed 59071, less than
> half of what the vanilla kernel reclaimed. i.e. the bulk of pages reclaimed
> with the compaction kernel were to get from 87% of memory allocated to 91%
> as huge pages.
> 
> These results would appear to be an encouraging enough start.
> 
> Comments?

I think "Total pages reclaimed" increasing is not good thing ;)
Honestly, I haven't understand why your patch increase reclaimed and
the exactly meaning of the your tool's rclm field.

Can you share your mesurement script? May I run the same test?

I like this patch, but I don't like increasing reclaim. I'd like to know
this patch require any vmscan change and/or its change mitigate the issue.

Thanks.



