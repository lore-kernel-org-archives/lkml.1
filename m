Return-Path: <linux-kernel-owner+w=401wt.eu-S2992876AbXCCBbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992876AbXCCBbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992826AbXCCBbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:31:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992876AbXCCBbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:31:22 -0500
Message-ID: <45E8CFD8.7050808@redhat.com>
Date: Fri, 02 Mar 2007 20:31:04 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] free swap space of (re)activated pages
References: <45E88997.4050308@redhat.com> <20070302171818.d271348e.akpm@linux-foundation.org>
In-Reply-To: <20070302171818.d271348e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 02 Mar 2007 15:31:19 -0500
> Rik van Riel <riel@redhat.com> wrote:
> 
>> the attached patch frees the swap space of already resident pages
>> when swap space starts getting tight, instead of only freeing up
>> the swap space taken up by newly swapped in pages.
>>
>> This should result in the swap space of pages that remain resident
>> in memory being freed, allowing kswapd more chances to actually swap
>> a page out (instead of rotating it back onto the active list).
> 
> Fair enough.   How do we work out if this helps things?

I suspect it should mostly help on desktop systems that slowly
fill up (and run out of) swap.  I'm not sure how to create that
synthetically.

I have seen that swap is kept free much easier in a qsbench
test, but that's probably not a very good test since it swaps
things in and out all the time...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
