Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbYAaKji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbYAaKji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765881AbYAaKio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:38:44 -0500
Received: from sacred.ru ([62.205.161.221]:45286 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763214AbYAaKim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:38:42 -0500
Message-ID: <47A1A527.9040705@openvz.org>
Date: Thu, 31 Jan 2008 13:38:31 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make nf_ct_path[] static
References: <20080130200259.GE29368@does.not.exist>
In-Reply-To: <20080130200259.GE29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 31 Jan 2008 13:38:18 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global nf_ct_path[] static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

Thanks, Adrian!

> ---
> 6396fbcebe3eb61f7e6eb1a671920a515912b005 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 696074a..5bd38a6 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -380,7 +380,7 @@ static ctl_table nf_ct_netfilter_table[] = {
>  	{ .ctl_name = 0 }
>  };
>  
> -struct ctl_path nf_ct_path[] = {
> +static struct ctl_path nf_ct_path[] = {
>  	{ .procname = "net", .ctl_name = CTL_NET, },
>  	{ }
>  };
> 
> 

