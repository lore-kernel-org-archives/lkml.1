Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbZDOK3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbZDOK3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDOK33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:29:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZDOK32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:29:28 -0400
Subject: Re: [PATCH] GFS2: Use DEFINE_SPINLOCK
From: Steven Whitehouse <swhiteho@redhat.com>
To: Xu Gang <xug@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1239692054-22797-1-git-send-email-xug@cn.fujitsu.com>
References: xug@cn.fujitsu.com  <1239692054-22797-1-git-send-email-xug@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 15 Apr 2009 11:30:32 +0100
Message-Id: <1239791432.3377.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As soon as my test build is done, I'll push this into the gfs2 git tree.
Thanks,

Steve.

On Tue, 2009-04-14 at 14:54 +0800, Xu Gang wrote:
> SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead.
> (as suggested in Documentation/spinlocks.txt)
> 
> Signed-off-by: Xu Gang <xug@cn.fujitsu.com>
> ---
>  fs/gfs2/quota.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 8d53f66..56fb9a2 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -81,7 +81,7 @@ struct gfs2_quota_change_host {
>  
>  static LIST_HEAD(qd_lru_list);
>  static atomic_t qd_lru_count = ATOMIC_INIT(0);
> -static spinlock_t qd_lru_lock = SPIN_LOCK_UNLOCKED;
> +static DEFINE_SPINLOCK(qd_lru_lock);
>  
>  int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask)
>  {

