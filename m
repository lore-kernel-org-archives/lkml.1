Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXCPEFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXCPEFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 00:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXCPEFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 00:05:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:29538 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXCPEFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 00:05:20 -0400
X-IronPort-AV: i="4.14,290,1170651600"; 
   d="scan'208"; a="31370662:sNHT25459826"
Subject: Re: [PATCH] blackfin: balance parenthesis in macros
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
In-Reply-To: <200703152312.21981.m.kozlowski@tuxland.pl>
References: <200703152312.21981.m.kozlowski@tuxland.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 16 Mar 2007 12:02:27 +0800
Message-Id: <1174017747.20198.2.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 18:12 -0400, Mariusz Kozlowski wrote:
> Hello,
> 
>         This patch (against 2.6.21-rc3-mm1) balances parenthesis in blackfin
> header files.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  include/asm-blackfin/mach-bf535/bf535.h |    4 ++--
>  include/asm-blackfin/scatterlist.h      |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff -u linux-2.6.21-rc3-mm1-a/include/asm-blackfin/mach-bf535/bf535.h linux-2.6.21-rc3-mm1-b/include/asm-blackfin/mach-bf535/bf535.h
> --- linux-2.6.21-rc3-mm1-a/include/asm-blackfin/mach-bf535/bf535.h      2007-03-15 22:25:34.000000000 +0100
> +++ linux-2.6.21-rc3-mm1-b/include/asm-blackfin/mach-bf535/bf535.h      2007-03-15 22:33:09.000000000 +0100
> @@ -224,7 +224,7 @@
>  #define UART0_LSR_TEMT                 0x40    /* TSR and UARTx_thr both empty */
> 
>  #define UART0_MSR_ADDR         0xffc0180c      /* UART 0 Modem status register  16 bit */
> -#define UART0_MSR                      HALFWORD_REF(UART0_MSR_ADDR
> +#define UART0_MSR                      HALFWORD_REF(UART0_MSR_ADDR)
>  #define UART0_SCR_ADDR         0xffc0180e      /* UART 0 Scratch register  16 bit */
>  #define UART0_SCR                      HALFWORD_REF(UART0_SCR_ADDR)
>  #define UART0_IRCR_ADDR                0xffc01810      /* UART 0 IrDA Control register  16 bit */
> @@ -331,7 +331,7 @@
>  #define UART1_LSR_TEMT          0x40   /* TSR and UARTx_thr both empty */
> 
>  #define UART1_MSR_ADDR         0xffc01c0c      /* UART 1 Modem status register  16 bit */
> -#define UART1_MSR                      HALFWORD_REF(UART1_MSR_ADDR
> +#define UART1_MSR                      HALFWORD_REF(UART1_MSR_ADDR)
>  #define UART1_SCR_ADDR         0xffc01c0e      /* UART 1 Scratch register  16 bit */
>  #define UART1_SCR                      HALFWORD_REF(UART1_SCR_ADDR)
> 
> diff -upr linux-2.6.21-rc3-mm1-a/include/asm-blackfin/scatterlist.h linux-2.6.21-rc3-mm1-b/include/asm-blackfin/scatterlist.h
> --- linux-2.6.21-rc3-mm1-a/include/asm-blackfin/scatterlist.h   2007-03-15 22:25:34.000000000 +0100
> +++ linux-2.6.21-rc3-mm1-b/include/asm-blackfin/scatterlist.h   2007-03-15 22:30:18.000000000 +0100
> @@ -17,7 +17,7 @@ struct scatterlist {
>   * returns, or alternatively stop on the first sg_dma_len(sg) which
>   * is 0.
>   */
> -#define sg_address(sg) (page_address((sg)->page) + (sg)->offset
> +#define sg_address(sg) (page_address((sg)->page) + (sg)->offset)
>  #define sg_dma_address(sg)      ((sg)->dma_address)
>  #define sg_dma_len(sg)          ((sg)->length)
> 
> 
> 
> Regards,
> 
>         Mariusz Kozlowski

Thank you Mariusz,

Mike applied your patch to our SVN repo. I will send out blackfin-arch
update patch including your contribution later.

Your review is very helpful for our development.

Best regards,
-Bryan Wu
