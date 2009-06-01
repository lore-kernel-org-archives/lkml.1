Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZFAEvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZFAEvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 00:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZFAEvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 00:51:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45531
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbZFAEvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 00:51:40 -0400
Date: Sun, 31 May 2009 21:51:40 -0700 (PDT)
Message-Id: <20090531.215140.214511212.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: pyunyh@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1c: fix spelling error
From: David Miller <davem@davemloft.net>
In-Reply-To: <12438220782521-git-send-email-jie.yang@atheros.com>
References: <12438220782521-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 1 Jun 2009 10:07:58 +0800

> Fix spelling error
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>
 ...
> @@ -1115,7 +1115,7 @@ static int atl1c_stop_mac(struct atl1c_hw *hw)
>  
>  	AT_READ_REG(hw, REG_TXQ_CTRL, &data);
>  	data &= ~TXQ_CTRL_EN;
> -	AT_WRITE_REG(hw, REG_TWSI_CTRL, data);
> +	AT_WRITE_REG(hw, REG_TXQ_CTRL, data);
>  
>  	for (timeout = 0; timeout < AT_HW_MAX_IDLE_DELAY; timeout++) {
>  		AT_READ_REG(hw, REG_IDLE_STATUS, &data);

A spelling error would occur on human language text.

That's not what this is.

The code is referring to the wrong register, so it's a bug not a
spelling error.

Please fix your commit message and resubmit.
