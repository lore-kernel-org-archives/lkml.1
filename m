Return-Path: <linux-kernel-owner+w=401wt.eu-S945906AbXHMN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945906AbXHMN6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939696AbXHMKnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:43:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38734 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S939684AbXHMKnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:43:07 -0400
Date: Mon, 13 Aug 2007 11:49:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [70/2many] MAINTAINERS - ARPD SUPPORT
Message-ID: <20070813114942.04a5483c@the-village.bc.nu>
In-Reply-To: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>
References: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:23:36 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90c1b81..ac2226b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -697,6 +697,7 @@ ARPD SUPPORT
>  P:	Jonathan Layes
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> +F:	net/ipv4/arp.c

NAK

arp.c is the netdev people, ARPD is a corner case bit of code within it,
something your patterns don't actually cope with
