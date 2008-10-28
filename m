Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYJ1SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYJ1SqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbYJ1Spr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:45:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52521
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbYJ1Spq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:45:46 -0400
Date: Tue, 28 Oct 2008 11:45:24 -0700 (PDT)
Message-Id: <20081028.114524.89018707.davem@davemloft.net>
To: jianjun@zeuux.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Remove unused variable warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081028081457.GA19691@ubuntu>
References: <20081028081457.GA19691@ubuntu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9SIkedq016830

From: Jianjun Kong <jianjun@zeuux.org>
Date: Tue, 28 Oct 2008 16:14:57 +0800

Please send networking patches at least CC:'d to
netdev@vger.kernel.org so that it gets archived properly in patchwork:

	http://patchwork.ozlabs.org/project/netdev/list/

and thus doesn't get lost.

> net: Remove unused variable warning
> 'min_ds_timeout' and 'max_ds_timeout' are only used when CONFIG_AX25_DAMA_SLAVE is defined.
> 
> net/ax25/sysctl_net_ax25.c:27: warning: â€˜min_ds_timeoutâ€™ defined but not used
> net/ax25/sysctl_net_ax25.c:27: warning: â€˜max_ds_timeoutâ€™ defined but not used
> 
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> ---
>  net/ax25/sysctl_net_ax25.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
> index f288fc4..735ceef 100644
> --- a/net/ax25/sysctl_net_ax25.c
> +++ b/net/ax25/sysctl_net_ax25.c
> @@ -24,7 +24,9 @@ static int min_idle[1],			max_idle[] = {65535000};
>  static int min_n2[] = {1},		max_n2[] = {31};
>  static int min_paclen[] = {1},		max_paclen[] = {512};
>  static int min_proto[1],		max_proto[] = { AX25_PROTO_MAX };
> +#ifdef CONFIG_AX25_DAMA_SLAVE
>  static int min_ds_timeout[1],		max_ds_timeout[] = {65535000};
> +#endif
>  
>  static struct ctl_table_header *ax25_table_header;
>  
> -- 
> 1.5.6.3
> 
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
