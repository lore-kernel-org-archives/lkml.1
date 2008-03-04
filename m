Return-Path: <linux-kernel-owner+w=401wt.eu-S1765391AbYCDQVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765391AbYCDQVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762873AbYCDQVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:21:22 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:40065 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYCDQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:21:21 -0500
Date: Tue, 4 Mar 2008 08:19:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] mark netconsole broken
Message-Id: <20080304081941.a045b7fe.randy.dunlap@oracle.com>
In-Reply-To: <20080304080644.GC2947@elte.hu>
References: <20080203150246.50647fa4.akpm@linux-foundation.org>
	<20080203150744.cf7d0415.akpm@linux-foundation.org>
	<20080204044304.d244e761.akpm@linux-foundation.org>
	<20080206003412.dca555d4.akpm@linux-foundation.org>
	<20080206011643.d9021649.akpm@linux-foundation.org>
	<20080303210540.cea55e13.akpm@linux-foundation.org>
	<20080304080644.GC2947@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 09:06:44 +0100 Ingo Molnar wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > This netconsole regression is still present in current mainline.  
> > Rafael, can you please add it to the list?
> > 
> > It's strange that I can hit it on three separate machines with e100 
> > and e1000 yet nobody else has reported it (afaik).  Is nobody using 
> > netconsole?

Sorry, I don't read 100% of any mailing list.

I use netconsole on my automated testing systems daily or at
least as often as there is a linus (-git) or -mm release.
It's still working for me, but I'm not using an e100[0] driver,
I'm using a Broadcom.


> i'd suggest the patch below, to mark it broken.
> 
> 	Ingo
> 
> ---
>  drivers/net/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/net/Kconfig
> ===================================================================
> --- linux.orig/drivers/net/Kconfig
> +++ linux/drivers/net/Kconfig
> @@ -3109,7 +3109,7 @@ config NET_FC
>  
>  config NETCONSOLE
>  	tristate "Network console logging support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	depends on EXPERIMENTAL && BROKEN
>  	---help---
>  	If you want to log kernel messages over the network, enable this.
>  	See <file:Documentation/networking/netconsole.txt> for details.

---
~Randy
