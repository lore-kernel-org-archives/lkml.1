Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYCOQlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYCOQlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYCOQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:41:11 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:40554 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYCOQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:41:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/7] drivers/net/wireless/b43/lo.c: remove unused variable
Date: Sat, 15 Mar 2008 17:40:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0803151702120.24178@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0803151702120.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151740.21828.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 17:02:36 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The variable trsw_rx is initialized but never used otherwise.

You get a NACK for now. Most likely this is a bug and the variable
does actually have to be used somewhere. I'll take a look at it.

> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/net/wireless/b43/lo.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff -u -p a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
> --- a/drivers/net/wireless/b43/lo.c	2008-03-12 14:13:14.000000000 +0100
> +++ b/drivers/net/wireless/b43/lo.c	2008-03-15 15:56:58.000000000 +0100
> @@ -493,15 +493,12 @@ static void lo_measure_gain_values(struc
>  		max_rx_gain = 0;
>  
>  	if (has_loopback_gain(phy)) {
> -		int trsw_rx = 0;
>  		int trsw_rx_gain;
>  
>  		if (use_trsw_rx) {
>  			trsw_rx_gain = phy->trsw_rx_gain / 2;
> -			if (max_rx_gain >= trsw_rx_gain) {
> +			if (max_rx_gain >= trsw_rx_gain)
>  				trsw_rx_gain = max_rx_gain - trsw_rx_gain;
> -				trsw_rx = 0x20;
> -			}
>  		} else
>  			trsw_rx_gain = max_rx_gain;
>  		if (trsw_rx_gain < 9) {


-- 
Greetings Michael.
