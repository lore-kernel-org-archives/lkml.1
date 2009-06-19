Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZFSSf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZFSSf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZFSSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:35:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZFSSfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:35:47 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <63B19258-D345-472C-8923-1A7F91F466A1@redhat.com>
From: Jonathan Brassow <jbrassow@redhat.com>
To: randy.dunlap@oracle.com
In-Reply-To: <4A3BD7D2.6020803@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [dm-devel] [PATCH -next] dm: fix dm-log-userspace printk format
Date: Fri, 19 Jun 2009 13:32:56 -0500
References: <20090619172622.05adb236.sfr@canb.auug.org.au> <4A3BD7D2.6020803@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, I've pulled this into my patch as well.

  brassow

On Jun 19, 2009, at 1:24 PM, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix printk format warning:
>
> drivers/md/dm-log-userspace-transfer.c:110: warning: format '%lu'  
> expects type 'long unsigned int', but argument 4 has type 'size_t'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jonathan Brassow <dm-devel@redhat.com>
> Cc: dm-devel@redhat.com
> ---
> drivers/md/dm-log-userspace-transfer.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20090619.orig/drivers/md/dm-log-userspace-transfer.c
> +++ linux-next-20090619/drivers/md/dm-log-userspace-transfer.c
> @@ -108,7 +108,7 @@ static int fill_pkg(struct cn_msg *msg,
> 				*(pkg->data_size) = 0;
> 		} else if (tfr->data_size > *(pkg->data_size)) {
> 			DMERR("Insufficient space to receive package [%u] "
> -			      "(%u vs %lu)", tfr->request_type,
> +			      "(%u vs %zu)", tfr->request_type,
> 			      tfr->data_size, *(pkg->data_size));
>
> 			*(pkg->data_size) = 0;
>
>
> -- 
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

