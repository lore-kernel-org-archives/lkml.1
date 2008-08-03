Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYHCS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYHCS2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYHCS2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:28:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36605 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYHCS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:28:12 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5352"; a="5277794"
Message-ID: <4895F8CE.6010204@qualcomm.com>
Date: Sun, 03 Aug 2008 11:28:30 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: penberg@cs.helsinki.fi, cl@linux-foundation.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru>
In-Reply-To: <20080801000405.GA7072@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
> to hell with tunables.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  init/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -736,7 +736,7 @@ config VM_EVENT_COUNTERS
>  config SLUB_DEBUG
>  	default y
>  	bool "Enable SLUB debugging support" if EMBEDDED
> -	depends on SLUB && SYSFS
> +	depends on SLUB
>  	help
>  	  SLUB has extensive debug support features. Disabling these can
>  	  result in significant savings in code size. This also disables

While at it, can you guys move this into lib/Kconfig.debug ?

Max
