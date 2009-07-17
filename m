Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbZGQAQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbZGQAQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933722AbZGQAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:16:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45947 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933718AbZGQAQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:16:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] mm: shrink_inactive_lis() nr_scan accounting fix fix
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090716125516.GB28895@localhost>
References: <20090716095241.9D0D.A69D9226@jp.fujitsu.com> <20090716125516.GB28895@localhost>
Message-Id: <20090717091439.A906.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Jul 2009 09:16:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not a newly introduced problem, but this early break might under scan
> the list, if (max_scan > swap_cluster_max).  Luckily the only two
> callers all call with (max_scan <= swap_cluster_max).
> 
> What shall we do? The comprehensive solution may be to
> - remove the big do-while loop
> - replace sc->swap_cluster_max => max_scan
> - take care in the callers to not passing small max_scan values
> 
> Or to simply make this function more robust like this?

Sorry, I haven't catch your point. Can you please tell me your worried
scenario?




