Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbXCZUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbXCZUzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXCZUze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:55:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:50004 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbXCZUzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=oDQV2vqmDBb1NfgzbkuM8p3sk7+0yNUNexcMEKQcMfHPQ+nNcCPoxaqADW2L/kIj2c005NZF4RPR2/opiH1aspGxzPvyjKpBP9QOOn032W2yLEGk9n1Ugzlb4QqJwTJC3lGaxTlUohs5Fuk5rxMXUoWbDXE5ncBEXvpA5vlB32k=
Date: Mon, 26 Mar 2007 22:55:12 +0200
To: Brian Braunstein <brian@bristyle.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, vtun@office.satix.net, akpm@osdl.org,
       jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tun/tap: fixed hw address handling
Message-ID: <20070326205511.GB21991@Ahmed>
References: <460632E9.5030508@bristyle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460632E9.5030508@bristyle.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 01:29:29AM -0700, Brian Braunstein wrote:
> 
> From: Brian Braunstein <linuxkernel@bristyle.com>
> 

No need for this line. This line is used when you _forward_ another patch
from others. Signed-off-by is enough

> 
> Signed-off-by: Brian Braunstein <linuxkernel@bristyle.com>
> 
> ---
> 
> Kernel Version: 2.6.20.4
> 

It's always better to generate the patch against the latest -rc kernel.

> --- linux-2.6.20.4-ORIG/drivers/net/tun.c	2007-03-23 
> 12:52:51.000000000 -0700
> +++ linux-2.6.20.4/drivers/net/tun.c	2007-03-25 00:44:20.000000000 -0700
> @@ -18,6 +18,10 @@
> /*
>  *  Changes:
>  *
> + *  Brian Braunstein <linuxkernel@bristyle.com> 2007/03/23
> + *    Fixed hw address handling.  Now net_device.dev_addr is kept 
> consistent

Your mailer still wrap the long lines mistakenly as it did in the first
version of the patch.

Regards,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

