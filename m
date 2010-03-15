Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936066Ab0COJys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:54:48 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:51297 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935701Ab0COJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:54:47 -0400
Message-ID: <4B9E03E5.70702@rsk.demon.co.uk>
Date: Mon, 15 Mar 2010 09:54:45 +0000
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: ehames@gmail.com
CC: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: fix coding style in hfa834x_usb.c
References: <1268442475-9024-1-git-send-email-ehames@gmail.com>
In-Reply-To: <1268442475-9024-1-git-send-email-ehames@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/10 01:07, ehames@gmail.com wrote:
> From: Edgardo Hames <ehames@gmail.com>
> 
> This is a patch in hfa834x_usb.c to fix typedef declarations and long lines.
> 
> Signed-off-by: Edgardo Hames <ehames@gmail.com>
> ---
Hi Edgardo,

Definitely a good thing to get rid of the typedefs.

>  			printk(KERN_ERR
> -			       "cmd_initialize() failed on two attempts, results %d and %d\n",
> -			       result1, result2);
> +				"cmd_initialize() failed on two attempts,"
> +				" results %d and %d\n", result1, result2);
>  			usb_kill_urb(&hw->rx_urb);

But I don't think you should split up the printk strings (like this one)
as it make them difficult to grep for.


> @@ -3382,8 +3382,9 @@ retry:
>  			 * our request has been acknowledged. Odd,
>  			 * but our OUT URB is still alive...
>  			 */
> -			pr_debug
> -			    ("Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
> +			pr_debug("Causality violation: "
> +				 "please reboot Universe, or email "
> +				 "linux-wlan-devel@lists.linux-wlan.com\n");
>  			ctlx->state = CTLX_RESP_COMPLETE;
>  			break;

This mailing list is dead, so there's no point in still directing people
there, so you can just drop the second half of that message.

regards
Richard

