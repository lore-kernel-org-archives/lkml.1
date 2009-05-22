Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZEVMfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZEVMfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbZEVMfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:35:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbZEVMfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:35:12 -0400
Date: Fri, 22 May 2009 08:33:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 04/18] io-controller: Modify cfq to make use of flat
	elevator fair queuing
Message-ID: <20090522123318.GB14972@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-5-git-send-email-vgoyal@redhat.com> <4A166829.6070608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A166829.6070608@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 04:54:01PM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> Since thinking time logic is moving to common layer, corresponding items
> in cic is not needed.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
> diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
> index ed52a1f..1fe9d78 100644
> --- a/include/linux/iocontext.h
> +++ b/include/linux/iocontext.h
> @@ -42,10 +42,6 @@ struct cfq_io_context {
>  	unsigned long last_end_request;
>  	sector_t last_request_pos;
>  
> -	unsigned long ttime_total;
> -	unsigned long ttime_samples;
> -	unsigned long ttime_mean;
> -
>  	unsigned int seek_samples;
>  	u64 seek_total;
>  	sector_t seek_mean;
> 

Thanks Gui. Queued for next posting.

Thanks
Vivek
