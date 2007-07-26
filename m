Return-Path: <linux-kernel-owner+w=401wt.eu-S935853AbXGZQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935853AbXGZQtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761548AbXGZQtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:49:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49252 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbXGZQtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:49:03 -0400
Message-ID: <46A8D076.6040400@garzik.org>
Date: Thu, 26 Jul 2007 12:48:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ax88796 (address space): cast to unsigned long, not long
References: <E1IE6KD-0005Tp-S8@ZenIV.linux.org.uk>
In-Reply-To: <E1IE6KD-0005Tp-S8@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/ax88796.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
> index 1d88236..e43e804 100644
> --- a/drivers/net/ax88796.c
> +++ b/drivers/net/ax88796.c
> @@ -819,7 +819,7 @@ static int ax_probe(struct platform_device *pdev)
>  	}
>  
>  	ei_status.mem = ioremap(res->start, size);
> -	dev->base_addr = (long)ei_status.mem;
> +	dev->base_addr = (unsigned long)ei_status.mem;

ACK


