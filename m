Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYLVWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYLVWas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYLVWaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:30:06 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:50058 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbYLVWaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:30:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=RwLaPoh6rs7UF0+cJO1aLCFiSsSpeirNr2EZF13gGqgy1IWpUP1IXvIbr7XmXpdifa
         WdC9v0WoaMhLI9eZoXXciGvZDGU0ebF8Xl8VFiRWuj/1UnOKNx2tWfZIgTPlFTBX2FCq
         hSof7u1r/MNwNFo5de1UwSggzw+cuUBAu0HqQ=
Message-ID: <9929d2390812221430j1bc15607m58dd07a6ac8dec5@mail.gmail.com>
Date: Mon, 22 Dec 2008 14:30:00 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Hannes Eder" <hannes@hanneseder.net>,
       "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 11/27] drivers/net/igb: remove dead code (function 'igb_read_pci_cfg')
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081222191632.11807.3776.stgit@vmbox.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	 <20081222191632.11807.3776.stgit@vmbox.hanneseder.net>
X-Google-Sender-Auth: 9a384b0fd3c200f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 11:16 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this warning:
>
>  drivers/net/igb/e1000_mac.c:54: warning: 'igb_read_pci_cfg' defined but not used
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/net/igb/e1000_mac.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/igb/e1000_mac.c b/drivers/net/igb/e1000_mac.c
> index 137269d..97f0049 100644
> --- a/drivers/net/igb/e1000_mac.c
> +++ b/drivers/net/igb/e1000_mac.c
> @@ -50,13 +50,6 @@ void igb_remove_device(struct e1000_hw *hw)
>        kfree(hw->dev_spec);
>  }
>
> -static void igb_read_pci_cfg(struct e1000_hw *hw, u32 reg, u16 *value)
> -{
> -       struct igb_adapter *adapter = hw->back;
> -
> -       pci_read_config_word(adapter->pdev, reg, value);
> -}
> -
>  static s32 igb_read_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
>  {
>        struct igb_adapter *adapter = hw->back;
>


Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Sorry, I caught this earlier and meant to have patch pushed out last
week.  Thanks for correcting this.

-- 
Cheers,
Jeff
