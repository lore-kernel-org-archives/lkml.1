Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZFDSOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZFDSOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZFDSNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:13:53 -0400
Received: from kroah.org ([198.145.64.141]:46241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbZFDSNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:13:52 -0400
Date: Thu, 4 Jun 2009 10:56:12 -0700
From: Greg KH <greg@kroah.com>
To: Pranith Kumar <pranith.hacks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
Message-ID: <20090604175612.GB18605@kroah.com>
References: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com> <20090602214745.GB25921@kroah.com> <430c80e90906022349l6fa7a9b4lb73f0ab1980b3e63@mail.gmail.com> <20090603152152.GB25560@kroah.com> <4A27616C.6030802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27616C.6030802@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 11:23:48AM +0530, Pranith Kumar wrote:
> Greg KH wrote:
> > On Wed, Jun 03, 2009 at 12:19:26PM +0530, Pranith Kumar wrote:
> >   
> >> I am using Gmail, which does this. I haven't figured out how to
> >> configure this thing yet.
> >>     
> >
> > Please try reading Documentation/email-clients.txt and try again.
> >
> >   
> 
> Ok, I've configured my email client now. Resubmitting patch.
> 
> Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>
> 
> diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
> index ce04218..5e8bd94 100644
> --- a/drivers/staging/otus/ioctl.c
> +++ b/drivers/staging/otus/ioctl.c
> @@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, 
> struct athr_wlan_param *zdparm)
>      struct zsKeyInfo keyInfo;
>      struct usbdrv_private *macp = dev->ml_priv;
>      u16_t vapId = 0;
> +    int ii;

Nope, the patch is linewrapped and the whitespace is still messed up :(

Care to retry?

thanks,

greg k-h
