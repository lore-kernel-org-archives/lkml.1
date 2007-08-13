Return-Path: <linux-kernel-owner+w=401wt.eu-S964847AbXHMX4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847AbXHMX4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXHMX4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:56:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35618 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765692AbXHMX4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:56:11 -0400
Date: Mon, 13 Aug 2007 16:39:32 -0700
From: Greg KH <greg@kroah.com>
To: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Prakash Punnoor <prakash@punnoor.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.2
Message-ID: <20070813233932.GA8852@kroah.com>
References: <20070809214716.GA31414@kroah.com> <20070809214745.GA31425@kroah.com> <200708101626.21927.prakash@punnoor.de> <46BB89C0.5070301@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BB89C0.5070301@nvidia.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 05:40:16PM -0400, Ayaz Abdulla wrote:
>  Yes, you are right. Copy and paste error. I have attached a patch which will 
>  fix this issue.
> 
>  Thanks for catching it.
>  Ayaz
> 
>  Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
> 
> 
>  Prakash Punnoor wrote:
> > Hi,
> > I just noticed that PHY_OUI_VITESSE == PHY_OUI_REALTEK. Is that really 
> > intentional?
> >> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> >> index 42ba1c0..a361dba 100644
> >> --- a/drivers/net/forcedeth.c
> >> +++ b/drivers/net/forcedeth.c
> >> @@ -550,6 +550,8 @@ union ring_type {
> >> /* PHY defines */
> >> #define PHY_OUI_MARVELL	0x5043
> >> #define PHY_OUI_CICADA	0x03f1
> >> +#define PHY_OUI_VITESSE	0x01c1
> >> +#define PHY_OUI_REALTEK	0x01c1
> > - (?=                 =?)
> > //\ Prakash Punnoor /\\
> > V_/                 \_V

> --- old/drivers/net/forcedeth.c	2007-08-09 17:37:12.000000000 -0400
> +++ new/drivers/net/forcedeth.c	2007-08-09 17:37:07.000000000 -0400
> @@ -551,7 +551,7 @@
>  #define PHY_OUI_MARVELL	0x5043
>  #define PHY_OUI_CICADA	0x03f1
>  #define PHY_OUI_VITESSE	0x01c1
> -#define PHY_OUI_REALTEK	0x01c1
> +#define PHY_OUI_REALTEK	0x0732
>  #define PHYID1_OUI_MASK	0x03ff
>  #define PHYID1_OUI_SHFT	6
>  #define PHYID2_OUI_MASK	0xfc00

Is this something that really matters for this driver?  And if so, care
to send this patch to mainline as well as to the stable@kernel.org team
with a proper changelog?

thanks,

greg k-h
