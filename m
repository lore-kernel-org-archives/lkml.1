Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZJVVtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZJVVtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZJVVtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:49:32 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45288 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZJVVtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:49:31 -0400
Date: Thu, 22 Oct 2009 23:49:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] ONLY-APPLY-IF-STILL-FAILING Revert 373c0a7e,
	8aa7e847: Fix congestion_wait() sync/async vs read/write confusion
Message-ID: <20091022214934.GQ10727@kernel.dk>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-6-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256221356-26049-6-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22 2009, Mel Gorman wrote:
> Testing by Frans Pop indicates that in the 2.6.30..2.6.31 window at
> least that the commits 373c0a7e 8aa7e847 dramatically increased the
> number of GFP_ATOMIC failures that were occuring within a wireless
> driver. It was never isolated which of the changes was the exact problem
> and it's possible it has been fixed since. If problems are still
> occuring with GFP_ATOMIC in 2.6.31-rc5, then this patch should be
> applied to determine if the congestion_wait() callers are still broken.

I still think this is a complete red herring.

-- 
Jens Axboe

