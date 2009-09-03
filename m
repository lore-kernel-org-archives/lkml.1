Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbZICM1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbZICM1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZICM1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:27:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:63101 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZICM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:27:30 -0400
Date: Thu, 3 Sep 2009 15:27:27 +0300
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
Message-ID: <20090903122727.GA4465@matterhorn.verdurent.com>
Mail-Followup-To: Ivo Van Doorn <ivdoorn@gmail.com>,
	List Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
 <a32f33a40909030454y51905525g15a65cc8364b8eb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a32f33a40909030454y51905525g15a65cc8364b8eb5@mail.gmail.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Sep 03, Ivo Van Doorn wrote:
> > USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
> > defined. Remove it from rt2500usb.
> >
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> 
> NACK
> 
> Users have reported that this is a valid rt2500usb ID. You can thank the
> manufacturer of the dongle to produce dongles with the same USB ID but
> with different chipsets.
> 
> Ivo

Interesting. On my laptop, without this patch both the drivers are loaded
(lsmod), rt2500usb aborts without allocating a device successfully but I am
unable to associate to the AP.

With the patch, I am atleast able to associate to the AP. Perhaps there is
some other side-effect.

Regards,
Amit

> > ---
> >  drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> > index ce75426..2e9fac7 100644
> > --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> > +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> > @@ -2020,7 +2020,6 @@ static struct usb_device_id rt2500usb_device_table[] = {
> >        /* Ralink */
> >        { USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
> >        { USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
> > -       { USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
> >        { USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
> >        /* Sagem */
> >        { USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
> > --
> > 1.6.3.3
> >
> >

-- 
-------------------------------------------------------------------------
Amit Kucheria,				 Kernel Developer, Verdurent
-------------------------------------------------------------------------
