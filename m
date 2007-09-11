Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXIKPRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXIKPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXIKPRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:17:38 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26503 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbXIKPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:17:37 -0400
Subject: Re: + net-myri10ge-force-select-inet_lro.patch added to -mm tree
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, brice@myri.com, davem@davemloft.net
In-Reply-To: <200709110533.l8B5Xb9h027496@imap1.linux-foundation.org>
References: <200709110533.l8B5Xb9h027496@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 08:17:35 -0700
Message-Id: <1189523855.17477.1.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Miller committed a patch into git that's just like this a while
ago .. Should be safe to drop this one.

Daniel


On Mon, 2007-09-10 at 22:33 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      net: myri10ge: force select inet_lro
> has been added to the -mm tree.  Its filename is
>      net-myri10ge-force-select-inet_lro.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: net: myri10ge: force select inet_lro
> From: Daniel Walker <dwalker@mvista.com>
> 
> This driver uses the inet_lro facilities , but it doesn't force it to be
> enabled ..  Someone would have to know to enable inet_lro if they select
> the driver ..
> 
> Instead, just force INET_LRO if this driver is selected..
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Brice Goglin <brice@myri.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/net/Kconfig~net-myri10ge-force-select-inet_lro drivers/net/Kconfig
> --- a/drivers/net/Kconfig~net-myri10ge-force-select-inet_lro
> +++ a/drivers/net/Kconfig
> @@ -2084,6 +2084,7 @@ source "drivers/net/ixp2000/Kconfig"
>  config MYRI_SBUS
>  	tristate "MyriCOM Gigabit Ethernet support"
>  	depends on SBUS
> +	select INET_LRO
>  	help
>  	  This driver supports MyriCOM Sbus gigabit Ethernet cards.
>  
> _
> 
> Patches currently in -mm which might be from dwalker@mvista.com are
> 
> net-myri10ge-force-select-inet_lro.patch
> whitespace-fixes-time-syscalls.patch
> whitespace-fixes-process-accounting.patch
> whitespace-fixes-cpuset.patch
> whitespace-fixes-relayfs.patch
> whitespace-fixes-audit-filtering.patch
> whitespace-fixes-dma-channel-allocator.patch
> whitespace-fixes-fork.patch
> whitespace-fixes-module-loading.patch
> whitespace-fixes-panic-handling.patch
> whitespace-fixes-capability-syscalls.patch
> whitespace-fixes-syscall-auditing.patch
> whitespace-fixes-compat-syscalls.patch
> whitespace-fixes-system-auditing.patch
> whitespace-fixes-execution-domains.patch
> whitespace-fixes-interval-timers.patch
> whitespace-fixes-system-timers.patch
> whitespace-fixes-task-exit-handling.patch
> profile-likely-unlikely-macros.patch
> profile-likely-unlikely-macros-fix.patch
> 
> -
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

