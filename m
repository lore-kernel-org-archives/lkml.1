Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0BDUoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:44:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:58633 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755912Ab0BDUoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:44:30 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19i2YIXVkliJaU188l/d4cxxAkF90Ng1sTy2/5B3K
	mhhe9UbMBjJFXL
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: hadi@cyberus.ca
Subject: Re: patch net-restore-ip-source-validation.patch added to 2.6.32-stable tree
Date: Thu, 4 Feb 2010 21:24:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-sidux-686; KDE/4.3.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
References: <1265060041850@kroah.org> <1265308725.4651.14.camel@bigi> <1265313056.4651.18.camel@bigi>
In-Reply-To: <1265313056.4651.18.camel@bigi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002042124.13011.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 04 February 2010, jamal wrote:
> Ok, I was able to reproduce it finally. This fixes it:
> 
> ---
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index b6e7aae..469193c 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -220,6 +220,7 @@ static const struct trans_ctl_table
> trans_net_ipv4_conf_vars_table[] = {
>         { NET_IPV4_CONF_PROMOTE_SECONDARIES,    "promote_secondaries" },
>         { NET_IPV4_CONF_ARP_ACCEPT,             "arp_accept" },
>         { NET_IPV4_CONF_ARP_NOTIFY,             "arp_notify" },
> +       { NET_IPV4_CONF_SRC_VMARK,              "src_valid_mark" },
>         {}
>  };
> ---

2.6.32.8-rc1 + this patch boots fine for me on amd64, no problems left.

> Note we dont have that code anymore in current tree - thats why it
> was missed...
> If this works, Greg/Dave - please include it in the -stable patch.
[...]

Thanks a lot
	Stefa Lippers-Hollmann
