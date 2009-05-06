Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZEFVdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZEFVdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZEFVdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:33:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZEFVdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:33:43 -0400
Date: Wed, 6 May 2009 14:30:10 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?WzZdW01lZSBFd11bzrxdICEhISAtLSBYS0ogfHwgbWluZGxlc3MgOkQ=?= 
	<xiaokj@gmail.com>
Cc: Oliver Neukum <oliver@neukum.name>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Yet another Conexant Clone to add to cdc-acm.c
Message-ID: <20090506213010.GA18387@suse.de>
References: <2e609cef0905060747m281c15e8ybc8e20f9d4993178@mail.gmail.com> <20090506145832.GE3478@suse.de> <2e609cef0905061401n2412c448k755a152917f4b9d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e609cef0905061401n2412c448k755a152917f4b9d6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:01:22AM +0800, [6][Mee Ew][μ] !!! -- XKJ || mindless :D wrote:
> 2009/5/6 Greg KH <gregkh@suse.de>:
> > On Wed, May 06, 2009 at 10:47:14PM +0800, [6][Mee Ew][μ] !!! -- XKJ || mindless :D wrote:
> >> Dear Mighty Ones,
> >>
> >> Please be gentle with me. This is my first time...
> >>
> >> Shiro / Aztech (Singapore) has completely cloned the Conexant USB
> >> MODEM RD02-D400 and called it their UM-3100.
> >> With the errors, of course.
> >>
> >> I am trying my best to follow procedures here (as google tells,
> >> though), so if I am not right, please feel free to hurl insults back
> >> to this mailbox.
> >
> > Minor thing to change, we need a "Signed-off-by:" line, as per the
> > instructions in the file Documentation/SubmittingPatches.
> >
> > Care to add that to the patch description and resend the whole thing so
> > that we can apply it?
> >
> > thanks,
> >
> > greg k-h
> 
> Understood. I have added you again, this time, because Mr Oliver
> Neukum's email bounced on me the last time.
> 
> This patch adds another quirky Conexant USB Modem Clone to usb cdc-acm.c
> 
> This is to be applied to latest git. (Got off the website...)
> 
> Signed-off-by: Xiao Kaijian <xiaokj@gmail.com>

Ah, better, but your email client seems to have eaten all of the tabs
and spit out spaces instead.  Care to read
Documentation/email_clients.txt and try it again?

> --- a/drivers/usb/class/cdc-acm.c       2009-05-06 22:06:27.556488116 +0800
> +++ b/drivers/usb/class/cdc-acm.c       2009-05-06 22:12:56.648401202 +0800
> @@ -1375,6 +1375,13 @@ static struct usb_device_id acm_ids[] = {
>        { USB_DEVICE(0x0572, 0x1324), /* Conexant USB MODEM RD02-D400 */
>        .driver_info = NO_UNION_NORMAL, /* has no union descriptor */
>        },
> +       { USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
> +        .driver_info = NO_UNION_NORMAL, /* has no union descriptor.
> +                                          This is basically a clone of
> +                                          Conexant USB MODEM RD02-D400.
> +                                          Seems like NO_UNION_ _IS_ becoming
> +                                          NORMAL... */

Is the commentary really needed here?  The majority of devices do not
need this quirk, so i don't think it's really "normal"...

thanks,

greg k-h
