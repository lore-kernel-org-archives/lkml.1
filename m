Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbXKUPDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbXKUPDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXKUPDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:03:15 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:48976 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXKUPDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:03:14 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Felipe Balbi <me@felipebalbi.com>
Subject: Re: USB deadlock after resume
Date: Wed, 21 Nov 2007 16:03:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Markus Rechberger <mrechberger@gmail.com>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Laurent Pinchart <laurentp@cse-semaphore.com>
References: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com> <8eac96a88d4f5eea94927c0e64eaac36@felipebalbi.com>
In-Reply-To: <8eac96a88d4f5eea94927c0e64eaac36@felipebalbi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211603.20173.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 November 2007 schrieb Felipe Balbi:
> Hi,
> 
> On Wed, 21 Nov 2007 15:37:20 +0100, "Markus Rechberger"
> <mrechberger@gmail.com> wrote:

> > it's the usb_control_message which calls usb_kill_urb if I haven't got
> > it wrong. (if you're looking for some other information please let me
> > know)
> > Although, I got a bit further with it. The error seems to happen
> > earlier already.
> > If I load the driver, and do not access the device after suspending
> > all usb_control commands fail with -71 eproto.
> 
> This device shouldn't be suspended. AFAIK it should have auto_suspend
> disabled
> by default.
> 
> Try adding this device to drivers/usb/core/quirks.c with
> USB_QUIRK_NO_AUTOSUSPEND flag set. Something like:

Unless the device sets a flag it won't be autosuspended. Nevertheless
it will and must be suspended as the whole system is supended.

	Regards
		Oliver
