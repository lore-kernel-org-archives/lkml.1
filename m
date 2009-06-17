Return-Path: <linux-kernel-owner+w=401wt.eu-S1764353AbZFQJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764353AbZFQJTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZFQJTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:19:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51140 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZFQJTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:19:39 -0400
Message-ID: <4A38B4B4.7060101@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 17:17:40 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
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
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <1244513342-11758-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1244513342-11758-16-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +
> +struct io_group *rq_iog(struct request_queue *q, struct request *rq)
>  {
>  	return q->elevator->efqd.root_group;
>  }

There is no need for this function now.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 912ac6a..bfa79c9 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2522,11 +2522,6 @@ struct io_group *io_get_io_group(struct request_queue *q, struct bio *bio,
 {
 	return q->elevator->efqd.root_group;
 }
-
-struct io_group *rq_iog(struct request_queue *q, struct request *rq)
-{
-	return q->elevator->efqd.root_group;
-}
 EXPORT_SYMBOL(io_get_io_group);
 #endif /* CONFIG_GROUP_IOSCHED*/
 
-- 
1.5.4.rc3

