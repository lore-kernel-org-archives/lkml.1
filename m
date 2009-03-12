Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZCLCC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZCLCC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZCLCA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:00:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45043 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbZCLCA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:00:26 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       dhowells@redhat.com, torvalds@linux-foundation.org,
       peterz@infradead.org, Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20090312105226.88df3f63.minchan.kim@barrios-desktop>
References: <20090312100049.43A3.A69D9226@jp.fujitsu.com> <20090312105226.88df3f63.minchan.kim@barrios-desktop>
Message-Id: <20090312105622.43A6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 12 Mar 2009 11:00:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Kosaki-san. 
> 
> I think ramfs pages's unevictablility should not depend on CONFIG_UNEVICTABLE_LRU.
> It would be better to remove dependency of CONFIG_UNEVICTABLE_LRU ?
> 
> How about this ? 
> It's just RFC. It's not tested. 
> 
> That's because we can't reclaim that pages regardless of whether there is unevictable list or not

maybe, your patch work.

but we can remove CONFIG_UNEVICTABLE_LRU build option itself completely 
after nommu folks confirmed CONFIG_UNEVICTABLE_LRU works well on their machine

it is more cleaner IMHO.
What do you think?



