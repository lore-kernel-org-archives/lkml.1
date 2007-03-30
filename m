Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbXC3OjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbXC3OjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbXC3OjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:39:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:21808 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXC3OjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,353,1170662400"; 
   d="scan'208"; a="219263599:sNHT23867144"
Message-ID: <460D2108.1080101@intel.com>
Date: Fri, 30 Mar 2007 07:39:04 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       auke-jan.h.kok@intel.com
Subject: Re: 2.6.21-rc5-mm3: fix e1000 compilation
References: <20070330085029.GA6556@localhost.sw.ru>
In-Reply-To: <20070330085029.GA6556@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2007 14:39:05.0063 (UTC) FILETIME=[2A8BE770:01C772D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
>   CC [M]  drivers/net/e1000/e1000_main.o
> drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
> drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
> 	...
> 

can you send me your config? I'd like to see why nobody here didn't spot this on 
any of our tests.

thanks,

Auke


> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -32,6 +32,8 @@ #include <linux/init.h>
>  #include <linux/vmalloc.h>
>  #include <linux/pagemap.h>
>  #include <linux/netdevice.h>
> +#include <linux/tcp.h>
> +#include <linux/ipv6.h>
>  #include <net/checksum.h>
>  #include <net/ip6_checksum.h>
>  #include <linux/mii.h>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
