Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbXIIKtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbXIIKtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 06:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXIIKtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 06:49:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60996 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXIIKtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 06:49:03 -0400
Date: Sun, 9 Sep 2007 03:52:12 -0700
From: Greg KH <greg@kroah.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Problem charging blackberry 8700c with berry_charge (2.6.22.6)
Message-ID: <20070909105212.GA14929@kroah.com>
References: <20070908220229.6e669e62.kernel1@cyberdogtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908220229.6e669e62.kernel1@cyberdogtech.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 10:02:29PM -0400, Matt LaPlante wrote:
> I'm running the 2.6.22.6 kernel with the berry_charge module loaded.
> I connect my 8700c via USB, but the blackberry does not appear to
> charge. The power icon does not change, and even after staying
> connected for an extended period, the device does not appear to be
> gaining any power.  The cable is good, as I can plug it into my
> Windows machine and it begins charging immediately.  I see the
> following in dmesg:
> 
> [ 6638.606493] usb 1-2: new full speed USB device using uhci_hcd and address 2
> [ 6638.776524] usb 1-2: configuration #1 chosen from 1 choice
> [ 6639.639611] usbcore: registered new interface driver berry_charge
> [ 6639.837097] usb 1-2: Second magic command failed: -71.


Ick, that's not nice.  Can you enable CONFIG_USB_DEBUG and debugging for
the berry_charge driver:
	modprobe berry_charge debug=1

and let us know what happens?

thanks,

greg k-h
