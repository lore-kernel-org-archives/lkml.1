Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZFVBrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZFVBrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 21:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZFVBrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 21:47:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZFVBrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 21:47:40 -0400
Message-ID: <4A3EE245.7030409@cn.fujitsu.com>
Date: Mon, 22 Jun 2009 09:45:41 +0800
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
Subject: Re: [PATCH 15/20] io-controller: map async requests to appropriate
 cgroup
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1245443858-8487-16-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o So far we were assuming that a bio/rq belongs to the task who is submitting
>   it. It did not hold good in case of async writes. This patch makes use of
>   blkio_cgroup pataches to attribute the aysnc writes to right group instead
>   of task submitting the bio.
> 
> o For sync requests, we continue to assume that io belongs to the task
>   submitting it. Only in case of async requests, we make use of io tracking
>   patches to track the owner cgroup.
> 
> o So far cfq always caches the async queue pointer. With async requests now
>   not necessarily being tied to submitting task io context, caching the
>   pointer will not help for async queues. This patch introduces a new config
>   option CONFIG_TRACK_ASYNC_CONTEXT. If this option is not set, cfq retains
>   old behavior where async queue pointer is cached in task context. If it
>   is not set, async queue pointer is not cached and we take help of bio

Here "If it is not set" should be "If it is set".


-- 
Regards
Gui Jianfeng

