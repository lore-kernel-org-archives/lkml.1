Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbYCCRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbYCCRhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbYCCRZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:25:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:45382 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbYCCRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:25:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,438,1199692800"; 
   d="scan'208";a="214349033"
Message-ID: <47CC3453.9010108@intel.com>
Date: Mon, 03 Mar 2008 09:24:35 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jeff Garzik <jeff@garzik.org>,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] #if 0 e1000e_read_nvm_spi()
References: <20080301162302.GX25835@cs181133002.pp.htv.fi>
In-Reply-To: <20080301162302.GX25835@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2008 17:25:26.0914 (UTC) FILETIME=[923ABE20:01C87D53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch #if 0's the no longer used e1000e_read_nvm_spi().

OK, thanks Adrian

I'll send a patch to remove the function alltogether.

Auke


> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/net/e1000e/e1000.h |    1 -
>  drivers/net/e1000e/lib.c   |    2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> 9bab4dc421a7e5a947739e2fa1363b4efffbcbe2 foobar
> diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
> index 327c062..6e0c6ed 100644
> --- a/drivers/net/e1000e/e1000.h
> +++ b/drivers/net/e1000e/e1000.h
> @@ -462,7 +462,6 @@ extern s32 e1000e_acquire_nvm(struct e1000_hw *hw);
>  extern s32 e1000e_write_nvm_spi(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
>  extern s32 e1000e_update_nvm_checksum_generic(struct e1000_hw *hw);
>  extern s32 e1000e_poll_eerd_eewr_done(struct e1000_hw *hw, int ee_reg);
> -extern s32 e1000e_read_nvm_spi(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
>  extern s32 e1000e_read_nvm_eerd(struct e1000_hw *hw, u16 offset, u16 words, u16 *data);
>  extern s32 e1000e_validate_nvm_checksum_generic(struct e1000_hw *hw);
>  extern void e1000e_release_nvm(struct e1000_hw *hw);
> diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
> index 95f75a4..cb2dac8 100644
> --- a/drivers/net/e1000e/lib.c
> +++ b/drivers/net/e1000e/lib.c
> @@ -1851,6 +1851,7 @@ static s32 e1000_ready_nvm_eeprom(struct e1000_hw *hw)
>  	return 0;
>  }
>  
> +#if 0
>  /**
>   *  e1000e_read_nvm_spi - Reads EEPROM using SPI
>   *  @hw: pointer to the HW structure
> @@ -1906,6 +1907,7 @@ s32 e1000e_read_nvm_spi(struct e1000_hw *hw, u16 offset, u16 words, u16 *data)
>  	nvm->ops.release_nvm(hw);
>  	return 0;
>  }
> +#endif  /*  0  */
>  
>  /**
>   *  e1000e_read_nvm_eerd - Reads EEPROM using EERD register
> 

