Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZHCR7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZHCR7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZHCR7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:59:12 -0400
Received: from mga06.intel.com ([134.134.136.21]:17771 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbZHCR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,315,1246863600"; 
   d="scan'208";a="538226167"
Date: Mon, 3 Aug 2009 20:01:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcf50633: fix wrong define for 10bit ADC mode
Message-ID: <20090803180122.GE28606@sortiz.org>
References: <200907281845.n6SIjq3m025462@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907281845.n6SIjq3m025462@home.pavel.comp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 01:09:04AM +0400, Paul Fertser wrote:
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  include/linux/mfd/pcf50633/adc.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
Applied, thanks a lot.

Cheers,
Samuel.

 
> diff --git a/include/linux/mfd/pcf50633/adc.h b/include/linux/mfd/pcf50633/adc.h
> index 56669b4..b35e628 100644
> --- a/include/linux/mfd/pcf50633/adc.h
> +++ b/include/linux/mfd/pcf50633/adc.h
> @@ -25,7 +25,8 @@
>  #define PCF50633_REG_ADCS3		0x57
>  
>  #define PCF50633_ADCC1_ADCSTART		0x01
> -#define PCF50633_ADCC1_RES_10BIT	0x02
> +#define PCF50633_ADCC1_RES_8BIT		0x02
> +#define PCF50633_ADCC1_RES_10BIT	0x00
>  #define PCF50633_ADCC1_AVERAGE_NO	0x00
>  #define PCF50633_ADCC1_AVERAGE_4	0x04
>  #define PCF50633_ADCC1_AVERAGE_8	0x08
> -- 
> 1.6.0.6
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
