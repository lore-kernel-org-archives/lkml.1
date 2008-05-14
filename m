Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYENIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYENIa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYENIaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:30:14 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:17509 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYENIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:30:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkBAGFAKkhR9P0I/2dsb2JhbAAIkxCaYg
Message-ID: <482AA313.7060409@246tnt.com>
Date: Wed, 14 May 2008 10:30:11 +0200
From: Sylvain Munaut <tnt@246tnt.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071124)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] fec_mpc52xx: MPC52xx_MESSAGES_DEFAULT: 2nd NETIF_MSG_IFDOWN
 => IFUP
References: <482A05E7.90204@gmail.com> <482A8DFD.3080805@246tnt.com> <482A9E83.6060703@gmail.com>
In-Reply-To: <482A9E83.6060703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
>> Yes but I remember seeing a patch for this already ... What kernel
>> version / revision do you have ?
>>
>> Sylvain
>>     
>
> Indeed I already sent the patch, see http://lkml.org/lkml/2008/1/30/252 (my
> emailaddress changed), but there was no response and the patch isn't included in
> current Linus' git. maybe if you could add your ack?
>   

Sure thing.

Acked-by: Sylvain Munaut <tnt@246tNt.com>

> ---
> duplicate NETIF_MSG_IFDOWN, 2nd should be NETIF_MSG_IFUP
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
> index 5f9c42e..329edd9 100644
> --- a/drivers/net/fec_mpc52xx.c
> +++ b/drivers/net/fec_mpc52xx.c
> @@ -78,7 +78,7 @@ module_param_array_named(mac, mpc52xx_fec_mac_addr, byte, NULL, 0);
>  MODULE_PARM_DESC(mac, "six hex digits, ie. 0x1,0x2,0xc0,0x01,0xba,0xbe");
>  
>  #define MPC52xx_MESSAGES_DEFAULT ( NETIF_MSG_DRV | NETIF_MSG_PROBE | \
> -		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFDOWN )
> +		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
>  static int debug = -1;	/* the above default */
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, "debugging messages level");
>
>   

