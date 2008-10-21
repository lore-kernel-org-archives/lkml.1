Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYJUGLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYJUGLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYJUGLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:11:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46188 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbYJUGLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:11:00 -0400
Message-ID: <48FD7267.1000704@garzik.org>
Date: Tue, 21 Oct 2008 02:10:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: ben@simtec.co.uk, davem@davemloft.net, vapier.adi@gmail.com,
       shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netdev: DM9000: remove BLACKFIN hacking in DM9000
 netdev driver
References: <1224178844-12496-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1224178844-12496-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> remove integer casting in the read/write IO accessors,
> because Blackfin now provides those functions
> 
> Tested-by: Javier Herrero <jherrero@hvsistemas.es>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/net/dm9000.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
> index f42c23f..5a9083e 100644
> --- a/drivers/net/dm9000.c
> +++ b/drivers/net/dm9000.c
> @@ -47,15 +47,6 @@
>  #define CARDNAME	"dm9000"
>  #define DRV_VERSION	"1.31"
>  
> -#ifdef CONFIG_BLACKFIN
> -#define readsb	insb
> -#define readsw	insw
> -#define readsl	insl
> -#define writesb	outsb
> -#define writesw	outsw
> -#define writesl	outsl
> -#endif

applied



