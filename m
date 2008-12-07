Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYLGIXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYLGIXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYLGIWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:22:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46934 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYLGIWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:22:52 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081205154006.GA19366@csn.ul.ie>
References: <Pine.LNX.4.64.0811071244330.5387@quilx.com> <20081205154006.GA19366@csn.ul.ie>
Message-Id: <20081207172115.53E1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun,  7 Dec 2008 17:22:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> ====== CUT HERE ======
> From: Mel Gorman <mel@csn.ul.ie>
> Subject: [RFC] Split per-cpu list into one-list-per-migrate-type
> 
> Currently the per-cpu page allocator searches the PCP list for pages of the
> correct migrate-type to reduce the possibility of pages being inappropriate
> placed from a fragmentation perspective. This search is potentially expensive
> in a fast-path and undesirable. Splitting the per-cpu list into multiple lists
> increases the size of a per-cpu structure and this was potentially a major
> problem at the time the search was introduced. These problem has been
> mitigated as now only the necessary number of structures is allocated for the
> running system.
> 
> This patch replaces a list search in the per-cpu allocator with one list
> per migrate type that should be in use by the per-cpu allocator - namely
> unmovable, reclaimable and movable.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Great.

this patch works well on my box too.
and my review didn't find any bug.

very thanks.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




