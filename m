Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXH0BUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXH0BUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbXH0BUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:20:31 -0400
Received: from smtp20.orange.fr ([80.12.242.27]:40595 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXH0BUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:20:30 -0400
X-ME-UUID: 20070826220352889.D93E11C00086@mwinf2017.orange.fr
Date: Mon, 27 Aug 2007 01:03:52 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: For irda update sysctl_checks list of
	binary paths.
Message-ID: <20070826220352.GB3881@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu> <20070823141652.d488a6e0.akpm@linux-foundation.org> <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com> <m1sl69mvrw.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sl69mvrw.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 09:55:15PM -0600, Eric W. Biederman wrote:
> 
> It turns out that the net/irda code didn't register any of
> it's binary paths in the global sysctl.h header file so
> I missed them completely when making an authoritative list
> of binary sysctl paths in the kernel.  So add them to
> the list of valid binary sysctl paths.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>

> ---
>  kernel/sysctl_check.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index d5e0337..aa5b6f6 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -702,6 +702,24 @@ static struct trans_ctl_table trans_net_dccp_table[] = {
>  	{}
>  };
>  
> +static struct trans_ctl_table trans_net_irda_table[] = {
> +	{ NET_IRDA_DISCOVERY,		"discovery" },
> +	{ NET_IRDA_DEVNAME,		"devname" },
> +	{ NET_IRDA_DEBUG,		"debug" },
> +	{ NET_IRDA_FAST_POLL,		"fast_poll_increase" },
> +	{ NET_IRDA_DISCOVERY_SLOTS,	"discovery_slots" },
> +	{ NET_IRDA_DISCOVERY_TIMEOUT,	"discovery_timeout" },
> +	{ NET_IRDA_SLOT_TIMEOUT,	"slot_timeout" },
> +	{ NET_IRDA_MAX_BAUD_RATE,	"max_baud_rate" },
> +	{ NET_IRDA_MIN_TX_TURN_TIME,	"min_tx_turn_time" },
> +	{ NET_IRDA_MAX_TX_DATA_SIZE,	"max_tx_data_size" },
> +	{ NET_IRDA_MAX_TX_WINDOW,	"max_tx_window" },
> +	{ NET_IRDA_MAX_NOREPLY_TIME,	"max_noreply_time" },
> +	{ NET_IRDA_WARN_NOREPLY_TIME,	"warn_noreply_time" },
> +	{ NET_IRDA_LAP_KEEPALIVE_TIME,	"lap_keepalive_time" },
> +	{}
> +};
> +
>  static struct trans_ctl_table trans_net_table[] = {
>  	{ NET_CORE,		"core",		trans_net_core_table },
>  	/* NET_ETHER not used */
> @@ -723,6 +741,7 @@ static struct trans_ctl_table trans_net_table[] = {
>  	{ NET_LLC,		"llc",		trans_net_llc_table },
>  	{ NET_NETFILTER,	"netfilter",	trans_net_netfilter_table },
>  	{ NET_DCCP,		"dccp",		trans_net_dccp_table },
> +	{ NET_IRDA,		"irda",		trans_net_irda_table },
>  	{ 2089,			"nf_conntrack_max" },
>  	{}
>  };
> -- 
> 1.5.1.1.181.g2de0
> 

