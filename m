Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYH0JTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYH0JTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYH0JTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:19:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYH0JTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:19:36 -0400
Message-ID: <48B51C19.9050800@pobox.com>
Date: Wed, 27 Aug 2008 05:19:21 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       toralf.foerster@gmx.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
References: <200808221033.46997.toralf.foerster@gmx.de> <Pine.LNX.4.64.0808221025070.6100@shark.he.net> <20080822181234.2f33e993@lxorguk.ukuu.org.uk> <20080822110902.432dd99e.akpm@linux-foundation.org> <20080822192415.1984d1c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20080822192415.1984d1c2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> For the record, and from memory, there were three patches.
> 
> I would go take a look at the archive if I was you: there were bits from
> Ingo and others too.
> 
> The diff you are looking for however appears to be this, which reverts part
> of the follow on patches to the correct original. I shall however refrain
> from looking smug because while the original wd patch was right I'm also the
> idiot who put the bug back into the tree.
> 
> Signed-off-by: Alan 'pass the paper bags' Cox <alan@redhat.com>
> 
> --- drivers/net/wd.c~	2008-08-22 19:17:01.000000000 +0100
> +++ drivers/net/wd.c	2008-08-22 19:17:01.000000000 +0100
> @@ -337,7 +337,7 @@
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	dev->poll_controller = ei_poll;
>  #endif
> -	NS8390p_init(dev, 0);
> +	NS8390_init(dev, 0);
>  
>  #if 1

applied


