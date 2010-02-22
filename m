Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0BVJGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:06:40 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60455 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0BVJGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:06:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mwk3NXVnlHmBZpoqmvacfhmtYtiLYLZLlj4fi1ndoegLo8a7MWj5vpm8zNTThYB1ly
         rCM0IQ3G8lA9pwkSaohjK/6sv+Y6gUR684zb0fwBSH6ySIJCjDNmcOriLG006cvbmBI6
         IfzRR9Unvtxq6vKofpzjTqKmmQSPbZil0r164=
MIME-Version: 1.0
In-Reply-To: <1266766047-3308-1-git-send-email-chris.nicholson@cnick.org.uk>
References: <1266766047-3308-1-git-send-email-chris.nicholson@cnick.org.uk>
Date: Mon, 22 Feb 2010 11:06:35 +0200
Message-ID: <269694c01002220106v20a0c32fkfea44dc8a022661e@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: mimio: Fix Coding style errors in mimio.c
From: Ameya Palande <2ameya@gmail.com>
To: Chris Nicholson <chris.nicholson@cnick.org.uk>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Sun, Feb 21, 2010 at 5:27 PM, Chris Nicholson
<chris.nicholson@cnick.org.uk> wrote:
> This is a patch to the mimio.c that fixes a couple of
> space errors picked up by checkpatch.pl
>
> Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
> ---
>  drivers/staging/mimio/mimio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/mimio/mimio.c b/drivers/staging/mimio/mimio.c
> index 1ba8103..4d7a602 100644
> --- a/drivers/staging/mimio/mimio.c
> +++ b/drivers/staging/mimio/mimio.c
> @@ -145,7 +145,7 @@ static void mimio_rx_handler(struct mimio *, unsigned char *, unsigned int);
>  static int mimio_tx(struct mimio *, const char *, int);
>
>  static char mimio_name[] = "VirtualInk mimio-Xi";
> -static struct usb_device_id mimio_table [] = {
> +static struct usb_device_id mimio_table[] = {
>        { USB_DEVICE(MIMIO_VENDOR_ID, MIMIO_PRODUCT_ID) },
>        { USB_DEVICE(0x0525, 0xa4a0) }, /* gadget zero firmware */
>        { }
> @@ -588,7 +588,7 @@ static int handle_mimio_rx_penupdown(struct mimio *mimio,
>                        *(mimio->pktbuf.p + 2);
>                if (x != *(mimio->pktbuf.p + 3)) {
>                        dev_dbg(&mimio->idev->dev, "EV_PEN%s: bad xsum.\n",
> -                               down ? "DOWN":"UP");
> +                               down ? "DOWN" : "UP");
>                        /* skip this event data */
>                        mimio->pktbuf.p += 4;
>                        /* decode any remaining events */
> --
> 1.6.6

I sent the same patch in Dec 2009 :(
http://driverdev.linuxdriverproject.org/pipermail/devel/2009-December/003128.html

It seems that mimio driver is already removed from linux-next:

commit c5982142e80229a90cd1a73eedef886de9c8e271
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Thu Feb 11 17:15:14 2010 -0800

    Staging: mimio: remove the mimio driver

Cheers,
Ameya.
