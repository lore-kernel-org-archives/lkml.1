Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbZKFXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbZKFXhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbZKFXh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:37:26 -0500
Received: from kroah.org ([198.145.64.141]:54829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760169AbZKFXhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:37:20 -0500
Date: Fri, 6 Nov 2009 14:59:31 -0800
From: Greg KH <greg@kroah.com>
To: Sebastian =?iso-8859-1?Q?Dalfu=DF?= <sd@sedf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 3/3 v2] staging: rt2860: reduce superfluous exclamation
 marks
Message-ID: <20091106225931.GD32205@kroah.com>
References: <20091106134812.GA27210@sedf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091106134812.GA27210@sedf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 02:48:12PM +0100, Sebastian Dalfuﬂ wrote:
> From: Sebastian Dalfuﬂ <sd@sedf.de>
> 
> This patch is based on next-20091106.
> This patch reduces the number of exclamation marks in DBGPRINT() and
> printk() strings (also comments) to a slightly less insane number.
> 
> Signed-off-by: Sebastian Dalfuﬂ <sd@sedf.de>
> ---
> diff -ru b/drivers/staging/rt2860/common/cmm_data.c c/drivers/staging/rt2860/common/cmm_data.c
> --- b/drivers/staging/rt2860/common/cmm_data.c	2009-11-06 08:03:10.000000000 +0100
> +++ c/drivers/staging/rt2860/common/cmm_data.c	2009-11-06 12:04:42.201639959 +0100
> @@ -1729,7 +1729,7 @@
>  				  pAd->MacTab.Size));
>  		} else {
>  			DBGPRINT(RT_DEBUG_OFF,
> -				 ("\n%s: Impossible Wcid = %d !!!!!\n",
> +				 ("\n%s: Impossible Wcid = %d !!!\n",

Heh, this is funny.  How did you determine that 3 '!' is acceptable when
4 or 5 '!' are not?

As this is a pretty pointless patch, I'm not going to apply it.

thanks,

greg k-h
