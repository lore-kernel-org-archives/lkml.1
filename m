Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZFBWRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZFBWRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZFBWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:17:47 -0400
Received: from kroah.org ([198.145.64.141]:35820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZFBWRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:17:46 -0400
Date: Tue, 2 Jun 2009 14:47:45 -0700
From: Greg KH <greg@kroah.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
Message-ID: <20090602214745.GB25921@kroah.com>
References: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 01:24:16PM +0530, Pranith Kumar wrote:
> Hi Greg,
> 
> This patch fixes the following warning
> 
> drivers/staging/otus/ioctl.c: In function `usbdrv_wpa_ioctl':
> drivers/staging/otus/ioctl.c:2269: warning: ISO C90 forbids mixed
> declarations and code
> drivers/staging/otus/ioctl.c: In function `usbdrv_ioctl':
> drivers/staging/otus/ioctl.c:2448: warning: ISO C90 forbids mixed
> declarations and code
> 
> Thanks,
> -- 
> Pranith.
> 
> Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>
> 
> diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
> index ce04218..26bd999 100644
> --- a/drivers/staging/otus/ioctl.c
> +++ b/drivers/staging/otus/ioctl.c
> @@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev,
> struct athr_wlan_param *zdparm)
>         struct zsKeyInfo keyInfo;
>         struct usbdrv_private *macp = dev->ml_priv;
>         u16_t vapId = 0;
> +    int ii;

Your patch is line-wrapped and the tabs seem to be stripped out, making
it impossible to apply :(

care to try again?

thanks,

greg k-h
