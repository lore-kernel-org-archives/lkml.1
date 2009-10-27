Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbZJ0SUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbZJ0SUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZJ0SUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbZJ0SUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:20:15 -0400
Message-ID: <4AE7397A.4010907@redhat.com>
Date: Tue, 27 Oct 2009 14:18:34 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org,
       " <rjw@sisk.pl>, Kernel Testers List <kernel-testers@vger.kernel.org>"@redhat.com
Subject: Re: [PATCH 3/3] vmscan: Force kswapd to take notice faster when high-order
 watermarks are being hit
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1256650833-15516-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2009 09:40 AM, Mel Gorman wrote:
> When a high-order allocation fails, kswapd is kicked so that it reclaims
> at a higher-order to avoid direct reclaimers stall and to help GFP_ATOMIC
> allocations. Something has changed in recent kernels that affect the timing
> where high-order GFP_ATOMIC allocations are now failing with more frequency,
> particularly under pressure. This patch forces kswapd to notice sooner that
> high-order allocations are occuring.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
