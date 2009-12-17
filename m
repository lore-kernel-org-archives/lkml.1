Return-Path: <linux-kernel-owner+w=401wt.eu-S934558AbZLQJaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558AbZLQJaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764153AbZLQJae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:30:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57702 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761261AbZLQJad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:30:33 -0500
Message-ID: <4B29F92B.2040602@cn.fujitsu.com>
Date: Thu, 17 Dec 2009 17:26:03 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 1/4] cfq-iosced: Remove the check for same cfq group from
 allow_merge
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <1261003980-10115-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1261003980-10115-2-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o allow_merge() already checks if submitting task is pointing to same cfqq
>   as rq has been queued in. If everything is fine, we should not be having
>   a task in one cgroup and having a pointer to cfqq in other cgroup.
> 
>   Well I guess in some situations it can happen and that is, when a random
>   IO queue has been moved into root cgroup for group_isolation=0. In
>   this case, tasks's cgroup/group is different from where actually cfqq is,
>   but this is intentional and in this case merging should be allowed.
> 
>   The second situation is where due to close cooperator patches, multiple
>   processes can be sharing a cfqq. If everything implemented right, we should
>   not end up in a situation where tasks from different processes in different
>   groups are sharing the same cfqq as we allow merging of cooperating queues
>   only if they are in same group.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

