Return-Path: <linux-kernel-owner+w=401wt.eu-S935902AbYGCHNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935902AbYGCHNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYGCG6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41008 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbYGCGDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:03:03 -0400
Date: Thu, 03 Jul 2008 15:02:23 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 1/10] fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR build
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>,
       Benjamin Kidwell <benjkidwell@yahoo.com>
In-Reply-To: <20080702223652.3b57dc4b.akpm@linux-foundation.org>
References: <20080625185950.D84F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080702223652.3b57dc4b.akpm@linux-foundation.org>
Message-Id: <20080703145454.B963.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  config UNEVICTABLE_LRU
> >  	bool "Add LRU list to track non-evictable pages"
> >  	default y
> > +	select PAGE_WALKER
> 
> So what do we do?  Make UNEVICTABLE_LRU depend on CONFIG_MMU?  That
> would be even worse than what we have now.

I'm not sure about what do we do. but I'd prefer "depends on MMU".
because current munlock implementation need pagewalker.
So, munlock rewriting have high risk rather than change depend on.

Rik, What do you think?



