Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbXIAMz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbXIAMz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 08:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXIAMzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 08:55:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbXIAMzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 08:55:19 -0400
Date: Sat, 1 Sep 2007 13:55:39 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] skge: unbalanced parenthesis fix
Message-ID: <20070901135539.40557930@oldman>
In-Reply-To: <200709010810.12798.m.kozlowski@tuxland.pl>
References: <200709010810.12798.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007 08:10:12 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This patch fixes unbalanced parenthesis.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/net/skge.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc4-mm1-a/drivers/net/skge.h	2007-09-01 07:23:52.000000000 +0200
> +++ linux-2.6.23-rc4-mm1-b/drivers/net/skge.h	2007-09-01 07:37:55.000000000 +0200
> @@ -1351,7 +1351,7 @@ enum {
>  	PHY_M_PC_EN_DET_PLUS	= 3<<8, /* Energy Detect Plus (Mode 2) */
>  };
> 
> -#define PHY_M_PC_MDI_XMODE(x)	((((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
> +#define PHY_M_PC_MDI_XMODE(x)	(((u16)(x)<<5) & PHY_M_PC_MDIX_MSK)
> 
>  enum {
>  	PHY_M_PC_MAN_MDI	= 0, /* 00 = Manual MDI configuration */

Since the macro is unused, I would rather just drop it.
