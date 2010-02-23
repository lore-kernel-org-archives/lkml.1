Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0BWOUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:20:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:53799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0BWOUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:20:15 -0500
Date: Tue, 23 Feb 2010 06:10:41 -0800
From: Greg KH <gregkh@suse.de>
To: Ameya Palande <2ameya@gmail.com>
Cc: Chris Nicholson <chris.nicholson@cnick.org.uk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: mimio: Fix Coding style errors in mimio.c
Message-ID: <20100223141041.GD2396@suse.de>
References: <1266766047-3308-1-git-send-email-chris.nicholson@cnick.org.uk>
 <269694c01002220106v20a0c32fkfea44dc8a022661e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <269694c01002220106v20a0c32fkfea44dc8a022661e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 11:06:35AM +0200, Ameya Palande wrote:
> Hi Chris,
> 
> On Sun, Feb 21, 2010 at 5:27 PM, Chris Nicholson
> <chris.nicholson@cnick.org.uk> wrote:
> > This is a patch to the mimio.c that fixes a couple of
> > space errors picked up by checkpatch.pl
> >
> > Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
> > ---
> >  drivers/staging/mimio/mimio.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/mimio/mimio.c b/drivers/staging/mimio/mimio.c
> > index 1ba8103..4d7a602 100644
> > --- a/drivers/staging/mimio/mimio.c
> > +++ b/drivers/staging/mimio/mimio.c
> > @@ -145,7 +145,7 @@ static void mimio_rx_handler(struct mimio *, unsigned char *, unsigned int);
> >  static int mimio_tx(struct mimio *, const char *, int);
> >
> >  static char mimio_name[] = "VirtualInk mimio-Xi";
> > -static struct usb_device_id mimio_table [] = {
> > +static struct usb_device_id mimio_table[] = {
> >        { USB_DEVICE(MIMIO_VENDOR_ID, MIMIO_PRODUCT_ID) },
> >        { USB_DEVICE(0x0525, 0xa4a0) }, /* gadget zero firmware */
> >        { }
> > @@ -588,7 +588,7 @@ static int handle_mimio_rx_penupdown(struct mimio *mimio,
> >                        *(mimio->pktbuf.p + 2);
> >                if (x != *(mimio->pktbuf.p + 3)) {
> >                        dev_dbg(&mimio->idev->dev, "EV_PEN%s: bad xsum.\n",
> > -                               down ? "DOWN":"UP");
> > +                               down ? "DOWN" : "UP");
> >                        /* skip this event data */
> >                        mimio->pktbuf.p += 4;
> >                        /* decode any remaining events */
> > --
> > 1.6.6
> 
> I sent the same patch in Dec 2009 :(
> http://driverdev.linuxdriverproject.org/pipermail/devel/2009-December/003128.html
> 
> It seems that mimio driver is already removed from linux-next:
> 
> commit c5982142e80229a90cd1a73eedef886de9c8e271
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Thu Feb 11 17:15:14 2010 -0800
> 
>     Staging: mimio: remove the mimio driver

Yes, sorry, the mimo driver is now gone for the 2.6.34 release.

greg k-h
