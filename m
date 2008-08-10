Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYHJAzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYHJAzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYHJAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:55:23 -0400
Received: from colo.lackof.org ([198.49.126.79]:38657 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYHJAzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:55:23 -0400
Date: Sat, 9 Aug 2008 18:55:11 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080810005511.GB2617@colo.lackof.org>
References: <20080806211155.GV1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806211155.GV1702@cs181140183.pp.htv.fi>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+bdale@hp.com

On Thu, Aug 07, 2008 at 12:11:55AM +0300, Adrian Bunk wrote:
> This patch adds the missing MODULE_LICENSE("GPL").
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 15 Jun 2008
> 
> 4cec562181f818f16f072b9a14ca7a0ce6c66417 diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
> index fdc36bf..6d3bebb 100644
> --- a/fs/binfmt_som.c
> +++ b/fs/binfmt_som.c
> @@ -308,3 +308,5 @@ static void __exit exit_som_binfmt(void)
>  
>  core_initcall(init_som_binfmt);
>  module_exit(exit_som_binfmt);
> +
> +MODULE_LICENSE("GPL");

Someone from HP needs to ACK this patch since I believe HP funded the code
changes made during the parisc-linux port. This should be a no-brainer
and I expect Bdale Garbee can quickly take care of this.

thanks,
grant
