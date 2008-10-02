Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYJBHAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYJBHAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYJBHAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:00:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53708 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYJBHAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:00:12 -0400
Date: Thu, 2 Oct 2008 16:05:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] pull out zone cpuset and watermark checks for reuse
Message-Id: <20081002160544.16570d27.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1222864261-22570-3-git-send-email-apw@shadowen.org>
References: <1222864261-22570-1-git-send-email-apw@shadowen.org>
	<1222864261-22570-3-git-send-email-apw@shadowen.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2008 13:30:59 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

> When allocating we need to confirm that the zone we are about to allocate
> from is acceptable to the CPUSET we are in, and that it does not violate
> the zone watermarks.  Pull these checks out so we can reuse them in a
> later patch.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

