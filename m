Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYGJA3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYGJA3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYGJA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:29:43 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49568 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYGJA3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:29:43 -0400
Date: Thu, 10 Jul 2008 02:30:55 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: remove DS1WM register definitions from asic3.h
Message-ID: <20080710003054.GC2637@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1215289005.23398.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215289005.23398.36.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 10:16:45PM +0200, Philipp Zabel wrote:
> There is a dedicated ds1wm driver, no need to duplicate this
> information here.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Applied, thanks.

> ---
>  include/linux/mfd/asic3.h |   38 +++-----------------------------------
>  1 files changed, 3 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
> index 0eae308..8f8c46c 100644
> --- a/include/linux/mfd/asic3.h
> +++ b/include/linux/mfd/asic3.h
> @@ -265,44 +265,12 @@ struct asic3_platform_data {
>  #define ASIC3_EXTCF_CF_SLEEP             (1 << 15) /* CF sleep mode control */
>  
>  /*********************************************
> - *  The Onewire interface registers
> - *
> - *  OWM_CMD
> - *  OWM_DAT
> - *  OWM_INTR
> - *  OWM_INTEN
> - *  OWM_CLKDIV
> + *  The Onewire interface (DS1WM) is handled
> + *  by the ds1wm driver.
>   *
>   *********************************************/
>  
> -#define ASIC3_OWM_Base		0xC00
> -
> -#define ASIC3_OWM_CMD         0x00
> -#define ASIC3_OWM_DAT         0x04
> -#define ASIC3_OWM_INTR        0x08
> -#define ASIC3_OWM_INTEN       0x0C
> -#define ASIC3_OWM_CLKDIV      0x10
> -
> -#define ASIC3_OWM_CMD_ONEWR         (1 << 0)
> -#define ASIC3_OWM_CMD_SRA           (1 << 1)
> -#define ASIC3_OWM_CMD_DQO           (1 << 2)
> -#define ASIC3_OWM_CMD_DQI           (1 << 3)
> -
> -#define ASIC3_OWM_INTR_PD          (1 << 0)
> -#define ASIC3_OWM_INTR_PDR         (1 << 1)
> -#define ASIC3_OWM_INTR_TBE         (1 << 2)
> -#define ASIC3_OWM_INTR_TEMP        (1 << 3)
> -#define ASIC3_OWM_INTR_RBF         (1 << 4)
> -
> -#define ASIC3_OWM_INTEN_EPD        (1 << 0)
> -#define ASIC3_OWM_INTEN_IAS        (1 << 1)
> -#define ASIC3_OWM_INTEN_ETBE       (1 << 2)
> -#define ASIC3_OWM_INTEN_ETMT       (1 << 3)
> -#define ASIC3_OWM_INTEN_ERBF       (1 << 4)
> -
> -#define ASIC3_OWM_CLKDIV_PRE       (3 << 0) /* two bits wide at bit 0 */
> -#define ASIC3_OWM_CLKDIV_DIV       (7 << 2) /* 3 bits wide at bit 2 */
> -
> +#define ASIC3_OWM_BASE		0xC00
>  
>  /*****************************************************************************
>   *  The SD configuration registers are at a completely different location
> -- 
> 1.5.6
> 
> 
