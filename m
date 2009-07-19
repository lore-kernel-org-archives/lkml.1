Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZGSNu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZGSNu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 09:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZGSNu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 09:50:58 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:32200 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302AbZGSNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 09:50:57 -0400
X-Trace: 232082011/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.87.228/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.87.228
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8FAO/AYkpPRVfk/2dsb2JhbACBUck0hAwF
X-IronPort-AV: E=Sophos;i="4.43,229,1246834800"; 
   d="scan'208";a="232082011"
Date: Sun, 19 Jul 2009 14:50:50 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 10/10] ksm: change ksm nice level to be 5
In-Reply-To: <1247851850-4298-11-git-send-email-ieidus@redhat.com>
Message-ID: <Pine.LNX.4.64.0907191450120.4601@sister.anvils>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com>
 <1247851850-4298-8-git-send-email-ieidus@redhat.com>
 <1247851850-4298-9-git-send-email-ieidus@redhat.com>
 <1247851850-4298-10-git-send-email-ieidus@redhat.com>
 <1247851850-4298-11-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Izik Eidus wrote:
> From: Izik Eidus <ieidus@redhat.com>
> 
> ksm should try not to disturb other tasks as much as possible.
> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  mm/ksm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 75d7802..4afe345 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1270,7 +1270,7 @@ static void ksm_do_scan(unsigned int scan_npages)
>  
>  static int ksm_scan_thread(void *nothing)
>  {
> -	set_user_nice(current, 0);
> +	set_user_nice(current, 5);
>  
>  	while (!kthread_should_stop()) {
>  		if (ksm_run & KSM_RUN_MERGE) {
> -- 
> 1.5.6.5
