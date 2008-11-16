Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYKPA7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYKPA7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYKPA7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:59:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46983 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYKPA7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:59:08 -0500
Message-ID: <491F704A.3010201@redhat.com>
Date: Sat, 15 Nov 2008 19:58:50 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] mm: evict streaming IO cache first
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Andrew,
> 
> I think we need this patch at 2.6.28.

I agree.  I thought we would need this patch from right before
the time I wrote it, but we had no good workload to demonstrate
it at the time.

Gene Heskett found that the problem happens on his system and
the patch fixes is.

> Can this thinking get acception?

One of the reasons that I could not find a justification for
the patch is that all the benchmarks that I tried were
unaffected by it.  This makes me believe that the risk of
performance regressions is low, while the patch does fix a
real performance bug for Gene's desktop.

-- 
All rights reversed.
