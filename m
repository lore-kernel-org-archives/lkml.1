Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZCWKlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZCWKlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZCWKlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:41:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZCWKlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:41:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1237752784-1989-2-git-send-email-hannes@cmpxchg.org>
References: <1237752784-1989-2-git-send-email-hannes@cmpxchg.org> <20090321102044.GA3427@cmpxchg.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 2/3] ramfs-nommu: use generic lru cache
Date: Mon, 23 Mar 2009 10:40:42 +0000
Message-ID: <11989.1237804842@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:

> Instead of open-coding the lru-list-add pagevec batching when
> expanding a file mapping from zero, defer to the appropriate page
> cache function that also takes care of adding the page to the lru
> list.
> 
> This is cleaner, saves code and reduces the stack footprint by 16
> words worth of pagevec.

Acked-by: David Howells <dhowells@redhat.com>
