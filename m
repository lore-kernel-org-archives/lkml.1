Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZELDBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZELDBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbZELDA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:00:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54979 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbZELDA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:00:56 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class citizen
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090512025246.GC7518@localhost>
References: <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025246.GC7518@localhost>
Message-Id: <20090512120002.D616.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 12:00:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> side effects
> ------------
> 
> This patch is safe in general, it restores the pre-2.6.28 mmap() behavior
> but in a much smaller and well targeted scope.
> 
> One may worry about some one to abuse the PROT_EXEC heuristic.  But as
> Andrew Morton stated, there are other tricks to getting that sort of boost.
> 
> Another concern is the PROT_EXEC mapped pages growing large in rare cases,
> and therefore hurting reclaim efficiency. But a sane application targeted for
> large audience will never use PROT_EXEC for data mappings. If some home made
> application tries to abuse that bit, it shall be aware of the consequences,
> which won't be disastrous even in the worst case.

ok, I lose.
if you can post good mesurement result, I'll ack this.



