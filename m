Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbYENX1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbYENX1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYENX1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:27:40 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:55516 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbYENX1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:27:39 -0400
Date: Thu, 15 May 2008 00:27:22 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20080514232722.GA12314@srcf.ucam.org>
References: <20080514221519.GA6575@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514221519.GA6575@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Input: add appleir USB driver
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 03:15:19PM -0700, Greg KH wrote:

> +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },

Hm. How is the IRCONTROL4 handled? Is the protocol completely different?

> +	  Say Y here if you want to use a Apple USB remote control.  This
> +	  device is traditionally inside an Intel Apple Mac Mini, but might
> +	  show up in other places.

Minor nit, but it's supported on all the desktop Intel Macs and not just 
the Mini.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
