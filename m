Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471Ab0ADOFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0ADOFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460Ab0ADOFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:05:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab0ADOFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:05:41 -0500
Message-ID: <4B41F572.3080406@redhat.com>
Date: Mon, 04 Jan 2010 09:04:34 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Corrado Zoccolo <czoccolo@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] page allocator: Reduce fragmentation in buddy allocator
 by	adding buddies that are merging to the tail of the free lists
References: <20100104135545.GC6373@csn.ul.ie>
In-Reply-To: <20100104135545.GC6373@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 08:55 AM, Mel Gorman wrote:
> From: Corrado Zoccolo<czoccolo@gmail.com>
>
> In order to reduce fragmentation, this patch classifies freed pages in
> two groups according to their probability of being part of a high order
> merge. Pages belonging to a compound whose next-highest buddy is free are
> more likely to be part of a high order merge in the near future, so they
> will be added at the tail of the freelist. The remaining pages are put at
> the front of the freelist.

> [mel@csn.ul.ie: Tested, reworked for less branches]
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
