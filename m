Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZLUXjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZLUXjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZLUXjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:39:40 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:12550 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZLUXjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:39:39 -0500
Message-ID: <4B3005D5.9070608@chelsio.com>
Date: Mon, 21 Dec 2009 15:33:41 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/7] drivers/net/cxgb3: Use kzalloc for allocating only
 one thing
References: <Pine.LNX.4.64.0912190816340.30546@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912190816340.30546@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2009 23:41:57.0312 (UTC) FILETIME=[2EF76C00:01CA8297]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
>
> From: Julia Lawall <julia@diku.dk>
>
> Use kzalloc rather than kcalloc(1,...)
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> @@
>
> - kcalloc(1,
> + kzalloc(
>           ...)
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>

Acked-by: Divy Le Ray <divy@chelsio.com>

>
> ---
>  drivers/net/cxgb3/cxgb3_offload.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p a/drivers/net/cxgb3/cxgb3_offload.c 
> b/drivers/net/cxgb3/cxgb3_offload.c
> --- a/drivers/net/cxgb3/cxgb3_offload.c 2009-09-14 14:55:49.000000000 
> +0200
> +++ b/drivers/net/cxgb3/cxgb3_offload.c 2009-12-19 07:52:52.000000000 
> +0100
> @@ -1252,7 +1252,7 @@ int cxgb3_offload_activate(struct adapte
>         struct mtutab mtutab;
>         unsigned int l2t_capacity;
>
> -       t = kcalloc(1, sizeof(*t), GFP_KERNEL);
> +       t = kzalloc(sizeof(*t), GFP_KERNEL);
>         if (!t)
>                 return -ENOMEM;
>


