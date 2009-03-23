Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZCWCXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZCWCXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 22:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZCWCXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 22:23:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56025 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZCWCXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 22:23:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 2/3] ramfs-nommu: use generic lru cache
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <1237752784-1989-2-git-send-email-hannes@cmpxchg.org>
References: <20090321102044.GA3427@cmpxchg.org> <1237752784-1989-2-git-send-email-hannes@cmpxchg.org>
Message-Id: <20090323112219.69F6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 11:22:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead of open-coding the lru-list-add pagevec batching when
> expanding a file mapping from zero, defer to the appropriate page
> cache function that also takes care of adding the page to the lru
> list.
> 
> This is cleaner, saves code and reduces the stack footprint by 16
> words worth of pagevec.

Looks good to me. thanks good patch.


