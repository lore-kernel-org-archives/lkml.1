Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZK0EgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZK0EgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZK0EgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:36:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34156 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZK0EgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:36:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
Cc: kosaki.motohiro@jp.fujitsu.com, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20091126121945.GB13095@csn.ul.ie>
References: <20091126121945.GB13095@csn.ul.ie>
Message-Id: <20091127133511.A7DB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 27 Nov 2009 13:36:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  block/cfq-iosched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index aa1e953..dc33045 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2543,7 +2543,7 @@ static void *cfq_init_queue(struct request_queue *q)
>  	cfqd->cfq_slice[1] = cfq_slice_sync;
>  	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
>  	cfqd->cfq_slice_idle = cfq_slice_idle;
> -	cfqd->cfq_latency = 1;
> +	cfqd->cfq_latency = 0;
>  	cfqd->hw_tag = 1;
>  	cfqd->last_end_sync_rq = jiffies;
>  	return cfqd;

Great. Probably we can reenable this feature at 2.6.33. but there isn't any reason to take
any risk at 2.6.32. i.e. This simple disabling is best. I like this.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



