Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYEaB56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYEaB56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYEaB5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:57:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYEaB5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:57:49 -0400
Message-ID: <4840B095.9080803@pobox.com>
Date: Fri, 30 May 2008 21:57:41 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4 of 5] xen/blkfront: add __exit to module_exit() handlers
References: <297d1ce696670eae30a7.1212192094@localhost>
In-Reply-To: <297d1ce696670eae30a7.1212192094@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Jan Beulich <jbeulich@novell.com>
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/block/xen-blkfront.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1045,7 +1045,7 @@
>  module_init(xlblk_init);
>  
>  
> -static void xlblk_exit(void)
> +static void __exit xlblk_exit(void)
>  {
>  	return xenbus_unregister_driver(&blkfront);
>  }

ACK


