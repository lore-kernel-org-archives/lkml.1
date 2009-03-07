Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZCGLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZCGLOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 06:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZCGLOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 06:14:11 -0500
Received: from relay.2ka.mipt.ru ([194.85.80.65]:50316 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbZCGLOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 06:14:10 -0500
Date: Sat, 7 Mar 2009 14:14:03 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] w1: coding style cleanups in w1_io.c
Message-ID: <20090307111403.GA22522@2ka.mipt.ru>
References: <1236355790-13856-1-git-send-email-daniel@caiaq.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236355790-13856-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 05:09:50PM +0100, Daniel Mack (daniel@caiaq.de) wrote:
> This fixes a number of coding style issues I stubled over.
> 
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Looks good, thank you.
Ack. Andrew, please apply.

> ---
>  drivers/w1/w1_io.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
> index 442bd8b..3ebe972 100644
> --- a/drivers/w1/w1_io.c
> +++ b/drivers/w1/w1_io.c
> @@ -69,7 +69,7 @@ static u8 w1_touch_bit(struct w1_master *dev, int bit)
>  		return w1_read_bit(dev);
>  	else {
>  		w1_write_bit(dev, 0);
> -		return(0);
> +		return 0;
>  	}
>  }
>  
> @@ -184,17 +184,17 @@ static u8 w1_read_bit(struct w1_master *dev)
>   */
>  u8 w1_triplet(struct w1_master *dev, int bdir)
>  {
> -	if ( dev->bus_master->triplet )
> -		return(dev->bus_master->triplet(dev->bus_master->data, bdir));
> +	if (dev->bus_master->triplet)
> +		return dev->bus_master->triplet(dev->bus_master->data, bdir);
>  	else {
>  		u8 id_bit   = w1_touch_bit(dev, 1);
>  		u8 comp_bit = w1_touch_bit(dev, 1);
>  		u8 retval;
>  
> -		if ( id_bit && comp_bit )
> -			return(0x03);  /* error */
> +		if (id_bit && comp_bit)
> +			return 0x03;  /* error */
>  
> -		if ( !id_bit && !comp_bit ) {
> +		if (!id_bit && !comp_bit) {
>  			/* Both bits are valid, take the direction given */
>  			retval = bdir ? 0x04 : 0;
>  		} else {
> @@ -203,11 +203,11 @@ u8 w1_triplet(struct w1_master *dev, int bdir)
>  			retval = id_bit ? 0x05 : 0x02;
>  		}
>  
> -		if ( dev->bus_master->touch_bit )
> +		if (dev->bus_master->touch_bit)
>  			w1_touch_bit(dev, bdir);
>  		else
>  			w1_write_bit(dev, bdir);
> -		return(retval);
> +		return retval;
>  	}
>  }
>  
> -- 
> 1.6.1.3

-- 
	Evgeniy Polyakov
