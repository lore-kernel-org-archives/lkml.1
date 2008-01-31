Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbYAaKiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbYAaKiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765254AbYAaKhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:37:51 -0500
Received: from sacred.ru ([62.205.161.221]:45051 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763872AbYAaKhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:37:50 -0500
Message-ID: <47A1A4F4.2050906@openvz.org>
Date: Thu, 31 Jan 2008 13:37:40 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make struct ipv4_devconf static
References: <20080130200254.GC29368@does.not.exist>
In-Reply-To: <20080130200254.GC29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 31 Jan 2008 13:37:23 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> struct ipv4_devconf can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> ---
> 
>  include/linux/inetdevice.h |    2 --
>  net/ipv4/devinet.c         |    2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> 20262a3317069b1bdbf2b37f4002fa5322445914 
> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index 8d9eaae..fc4e3db 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -17,8 +17,6 @@ struct ipv4_devconf
>  	DECLARE_BITMAP(state, __NET_IPV4_CONF_MAX - 1);
>  };
>  
> -extern struct ipv4_devconf ipv4_devconf;
> -
>  struct in_device
>  {
>  	struct net_device	*dev;
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 21f71bf..5ab5acc 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -64,7 +64,7 @@
>  #include <net/rtnetlink.h>
>  #include <net/net_namespace.h>
>  
> -struct ipv4_devconf ipv4_devconf = {
> +static struct ipv4_devconf ipv4_devconf = {
>  	.data = {
>  		[NET_IPV4_CONF_ACCEPT_REDIRECTS - 1] = 1,
>  		[NET_IPV4_CONF_SEND_REDIRECTS - 1] = 1,
> 
> 

