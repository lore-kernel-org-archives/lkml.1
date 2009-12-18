Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZLRBlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZLRBlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZLRBlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:41:49 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1798 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZLRBls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:41:48 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Thu, 17 Dec 2009 17:41:39 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Roel Kluin" <roel.kluin@gmail.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Matthew Carlson" <mcarlson@broadcom.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] broadcom: bcm54xx_shadow_read() errors ignored in
 bcm54xx_adjust_rxrefclk()
Message-ID: <20091218014138.GA22080@xw6200.broadcom.net>
References: <4B28DA62.40909@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4B28DA62.40909@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 673402593J836500024-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:02:26AM -0800, Roel Kluin wrote:
> If not signed read errors are ignored.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Matt Carlson <mcarlson@broadcom.com>

> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index f63c96a..c13cf64 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -326,7 +326,8 @@ error:
>  
>  static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
>  {
> -	u32 val, orig;
> +	u32 orig;
> +	int val;
>  	bool clk125en = true;
>  
>  	/* Abort if we are using an untested phy. */
> 

