Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZK0NcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZK0NcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZK0NcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:32:17 -0500
Received: from smurf.noris.de ([192.109.102.42]:31994 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801AbZK0NcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:32:16 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 08:32:16 EST
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick
 to option driver
From: Matthias Urlichs <matthias@urlichs.de>
To: Gernot Hillier <gernot@hillier.de>
Cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4B0FCAD3.9000801@hillier.de>
References: <4B08F18C.3040904@hillier.de>
	 <200911220920.16717.oliver@neukum.org> <4B0C1F41.2060101@hillier.de>
	 <200911241919.10895.oliver@neukum.org>  <4B0FCAD3.9000801@hillier.de>
Content-Type: text/plain; charset="UTF-8"
Organization: {M:U} IT Design
Date: Fri, 27 Nov 2009 14:24:14 +0100
Message-ID: <1259328254.27675.524.camel@kiste>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 13:49 +0100, Gernot Hillier wrote:
> +       /* 4G Systems W14 simply ignores this message on interface 0 & 1 
> +          and would cause long timeouts when calling usb_control_msg()  */
> +       if (serial->dev->descriptor.idVendor == FOUR_G_SYSTEMS_VENDOR_ID &&
> +               serial->dev->descriptor.idProduct == FOUR_G_SYSTEMS_PRODUCT_W14 &&
> +               (ifNum == 0 || ifNum == 1) )
> +               return -EIO;
> 
I'd appreciate if you'd implement this generically.

I.e., use the driver_info field of struct usb_device for an appropriate
blacklist flag. (It's not going to be the only one.)


