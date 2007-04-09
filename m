Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbXDIJsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbXDIJsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 05:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXDIJsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 05:48:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15196 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXDIJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 05:48:19 -0400
X-IronPort-AV: i="4.14,387,1170651600"; 
   d="scan'208"; a="26724133:sNHT22553706"
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, waltje@uWalt.NL.Mugnet.ORG,
       Aubrey Li <aubreylee@gmail.com>
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com>
References: <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 09 Apr 2007 17:50:22 +0800
Message-Id: <1176112223.17975.8.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 11:01 +0800, Aubrey Li wrote:
> The option CONFIG_PACKET_MMAP should depend on MMU.
> 
> Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
> ---
>  net/packet/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/packet/Kconfig b/net/packet/Kconfig
> index 34ff93f..959c272 100644
> --- a/net/packet/Kconfig
> +++ b/net/packet/Kconfig
> @@ -17,7 +17,7 @@ config PACKET
> 
>  config PACKET_MMAP
>  	bool "Packet socket: mmapped IO"
> -	depends on PACKET
> +	depends on PACKET && MMU
>  	help
>  	  If you say Y here, the Packet protocol driver will use an IO
>  	  mechanism that results in faster communication.

Yeah, this is a bug found on blackfin arch and it is also for other
NOMMU arch. Is there any solution for this? We think Aubrey's idea
works.

Thanks
-Bryan
