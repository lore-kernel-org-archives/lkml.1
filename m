Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0BTRO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 12:14:26 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57959 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab0BTROZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 12:14:25 -0500
Date: Sat, 20 Feb 2010 18:14:23 +0100
From: Andreas Mohr <andi@lisas.de>
To: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andreas Mohr <andi@lisas.de>,
       Radek Liboska <liboska@uochb.cas.cz>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi: add CONTEC vendor and product id
Message-ID: <20100220171423.GA30123@rhlx01.hs-esslingen.de>
References: <6ea9ef0f1002200520w7ad62618hc680380142f5f0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ea9ef0f1002200520w7ad62618hc680380142f5f0d@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 20, 2010 at 10:20:50PM +0900, Daniel Sangorrin wrote:
> diff --git a/drivers/usb/serial/ftdi_sio_ids.h
> b/drivers/usb/serial/ftdi_sio_ids.h
> index c8951ae..545db7f 100644
> --- a/drivers/usb/serial/ftdi_sio_ids.h
> +++ b/drivers/usb/serial/ftdi_sio_ids.h
> @@ -1002,3 +1002,10 @@
>  #define EVO_8U232AM_PID	0x02FF	/* Evolution robotics RCM2 (FT232AM)*/
>  #define EVO_HYBRID_PID		0x0302	/* Evolution robotics RCM4 PID (FT232BM)*/
>  #define EVO_RCM4_PID		0x0303	/* Evolution robotics RCM4 PID */
> +
> +/*
> + * Contec products (http://www.contec.com)
> + * Submitted by Daniel Sangorrin
> + */
> +#define CONTEC_VID		0x06CE	/* Vendor ID */
> +#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */

This VID is not sorted (which also leads to a possibility of merge conflicts),
perhaps resubmit?

Apart from this: ACK (not that there would be much to not ACK here
though :)

Thanks for notifying driver stakeholders (I should have actually decided
to list my email address, too, though).

Thanks,

Andreas Mohr
