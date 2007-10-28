Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbXJ1Wnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbXJ1Wnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXJ1Wng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:43:36 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:46283 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXJ1Wng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:43:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=oDCTkZxCPH7NeXS9VDvjyckpX7WdmKhNKD/b911rwGVfgPUA1iuLl5rgwBfTy
	N4xd05OKPt9XkIaxXprC4ZN7w==
Date: Sun, 28 Oct 2007 23:43:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] fix breakage in pegasos_eth (fallout from commit b45d9147f1582333e180e1023624c003874b7312)
Message-ID: <20071028224334.GA11480@xi.wantstofly.org>
References: <20071027200232.GS8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027200232.GS8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 09:02:32PM +0100, Al Viro wrote:

> diff --git a/include/linux/mv643xx_eth.h b/include/linux/mv643xx_eth.h
> index 3f27239..8df230a 100644
> --- a/include/linux/mv643xx_eth.h
> +++ b/include/linux/mv643xx_eth.h
> @@ -8,6 +8,9 @@
>  #define MV643XX_ETH_NAME		"mv643xx_eth"
>  #define MV643XX_ETH_SHARED_REGS		0x2000
>  #define MV643XX_ETH_SHARED_REGS_SIZE	0x2000
> +#define MV643XX_ETH_BAR_4	0x220
> +#define MV643XX_ETH_SIZE_REG_4	0x224
> +#define MV643XX_ETH_BASE_ADDR_ENABLE_REG	0x0290

Ideally, pegasos_eth shouldn't be poking around in mv643xx_eth
registers directly (but I'll put that on the TODO list to try
and fix later.)
