Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab0BRQMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:12:40 -0500
Received: from kroah.org ([198.145.64.141]:60637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499Ab0BRQMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:12:33 -0500
Date: Thu, 18 Feb 2010 08:05:47 -0800
From: Greg KH <greg@kroah.com>
To: tim@weberpafrica.com
Cc: gregkh@suse.de, devel@driverdev.osuosl.org,
       Tim Schofield <tim.schofield1960@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:rtl8192e: fix comments style issue in
 r8180_93cx6.c This is a patch to the r8180_93cx6.c file that fixes up the
 comments styling issues found by the checkpatch.pl tool Signed-off-by: Tim
 Schofield <tim@weberpafrica.com>
Message-ID: <20100218160547.GJ21785@kroah.com>
References: <1266338116-27482-1-git-send-email-tim@weberpafrica.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266338116-27482-1-git-send-email-tim@weberpafrica.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 04:35:16PM +0000, tim@weberpafrica.com wrote:
> From: Tim Schofield <tim.schofield1960@googlemail.com>
> 
> ---
>  drivers/staging/rtl8192e/r8180_93cx6.c |   22 ++++++++++++++--------
>  1 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192e/r8180_93cx6.c b/drivers/staging/rtl8192e/r8180_93cx6.c
> index 262ed5f..60fba80 100644
> --- a/drivers/staging/rtl8192e/r8180_93cx6.c
> +++ b/drivers/staging/rtl8192e/r8180_93cx6.c
> @@ -23,12 +23,14 @@
>  static void eprom_cs(struct net_device *dev, short bit)
>  {
>  	if (bit)
> +		/* enable EPROM */
>  		write_nic_byte(dev, EPROM_CMD,
>  			       (1<<EPROM_CS_SHIFT) | \
> -			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
> +			       read_nic_byte(dev, EPROM_CMD));
>  	else
> +		/* disable EPROM */
>  		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
> -			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
> +			       &~(1<<EPROM_CS_SHIFT));

This does not do what you think it does (hint, you need {} if you want
to have more than one line in an if statement...)

Can you always verify that your coding style changes do not actually
break the code?  A simple comparison of the .ko file before and after
should be sufficient.

thanks,

greg k-h
