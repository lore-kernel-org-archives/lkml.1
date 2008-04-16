Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYDPShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYDPShT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYDPShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:37:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34825 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYDPShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:37:01 -0400
Message-ID: <4806474A.3020502@garzik.org>
Date: Wed, 16 Apr 2008 14:36:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Wappler Marcel <Marcel.Wappler@bridgeco.net>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: let the MII driver inform a MAC about changed wire
 speed
References: <83116F0A4FF67A4F97BA0B6E408C48E301F22BDD@zuerich.BC-Int.NET>
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E301F22BDD@zuerich.BC-Int.NET>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wappler Marcel wrote:
> This was tested on a ARM926 base SoC with an IP based ethernet MAC (10/100 MBit) together with a Realtek RTL8201 MII and a SMCSC
> 8700 RMII with kernel 2.6.24.
> 
> ---
> An Ethernet MAC needs to know the medium speed (10/100/1000 Mbps) of an RMII PHY in order to correctly interpret data originating
> from that PHY. The function mii_check_media() has been extended to allow retrieval of the medium speed by a MAC driver. A trivial
> modification to existing MAC drivers will allow them to cover operation with both MII and RMII PHYs.
> Signed-off-by: Marcel Wappler <marcel.wappler@bridgeco.net>

Please make sure to copy netdev list...

Queued for review.

	Jeff



