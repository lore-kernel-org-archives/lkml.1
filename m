Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0BEQES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:04:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:40232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752112Ab0BEQER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:04:17 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+qHWwEqrqq9TMUY3lrORNo0q1gpNlydllOV6mwqW
	8LKFAzDfB6NF5v
From: Sven Joachim <svenjoac@gmx.de>
To: hadi@cyberus.ca
Cc: Randolf Pohl <randolf.pohl@gmx.de>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [46/74] net: restore ip source validation
References: <20100205143441.280460@gmx.net> <1265381514.5661.1.camel@bigi>
Date: Fri, 05 Feb 2010 17:04:11 +0100
In-Reply-To: <1265381514.5661.1.camel@bigi> (jamal's message of "Fri, 05 Feb
	2010 09:51:54 -0500")
Message-ID: <87wryr4qkk.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-05 15:51 +0100, jamal wrote:

> The problem is elsewhere. Here's the fix.
>
> --
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

Well spotted, that fixes it.  Your mailer is broken however, it
converted tabs into spaces, so I had to add the changed line manually.

Sven
