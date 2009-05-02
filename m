Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZEBOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZEBOYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZEBOYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:24:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbZEBOYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:24:06 -0400
Message-ID: <49FC56EE.4080402@redhat.com>
Date: Sat, 02 May 2009 10:21:34 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH] vmscan: don't export nr_saved_scan in /proc/zoneinfo
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org> <20090501012212.GA5848@localhost> <20090430194907.82b31565.akpm@linux-foundation.org> <20090502023125.GA29674@localhost> <20090502024719.GA29730@localhost>
In-Reply-To: <20090502024719.GA29730@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> The lru->nr_saved_scan's are not meaningful counters for even kernel
> developers.  They typically are smaller than 32 and are always 0 for
> large lists. So remove them from /proc/zoneinfo.
> 
> Hopefully this interface change won't break too many scripts.
> /proc/zoneinfo is too unstructured to be script friendly, and I wonder
> the affected scripts - if there are any - are still bleeding since the
> not long ago commit "vmscan: split LRU lists into anon & file sets",
> which also touched the "scanned" line :)
> 
> If we are to re-export accumulated vmscan counts in the future, they
> can go to new lines in /proc/zoneinfo instead of the current form, or
> to /sys/devices/system/node/node0/meminfo?
> 
> CC: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
