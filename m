Return-Path: <linux-kernel-owner+w=401wt.eu-S1765971AbZFQNB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765971AbZFQNB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbZFQNBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:01:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45112 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171AbZFQNBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:01:14 -0400
Date: Wed, 17 Jun 2009 09:00:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 15/19] io-controller: map async requests to appropriate
	cgroup
Message-ID: <20090617130043.GC15473@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-16-git-send-email-vgoyal@redhat.com> <4A38B4B4.7060101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A38B4B4.7060101@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 05:17:40PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +struct io_group *rq_iog(struct request_queue *q, struct request *rq)
> >  {
> >  	return q->elevator->efqd.root_group;
> >  }
> 
> There is no need for this function now.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Queued up for next posting.

Vivek

> ---
>  block/elevator-fq.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 912ac6a..bfa79c9 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2522,11 +2522,6 @@ struct io_group *io_get_io_group(struct request_queue *q, struct bio *bio,
>  {
>  	return q->elevator->efqd.root_group;
>  }
> -
> -struct io_group *rq_iog(struct request_queue *q, struct request *rq)
> -{
> -	return q->elevator->efqd.root_group;
> -}
>  EXPORT_SYMBOL(io_get_io_group);
>  #endif /* CONFIG_GROUP_IOSCHED*/
>  
> -- 
> 1.5.4.rc3
