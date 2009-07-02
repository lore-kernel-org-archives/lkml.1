Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZGBXa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZGBXa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZGBXav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:30:51 -0400
Received: from kroah.org ([198.145.64.141]:53230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZGBXav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:30:51 -0400
Date: Thu, 2 Jul 2009 16:28:43 -0700
From: Greg KH <greg@kroah.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30 PL2303 USB-serial: NULL ptr dereference
Message-ID: <20090702232843.GA7865@kroah.com>
References: <m3vdmast7j.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3vdmast7j.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 10:52:48PM +0200, Krzysztof Halasa wrote:
> Hi,
> 
> Not sure if the following has been reported. I think happened when
> closing minicom, with the PL2303-based adapter still connected to USB.
> 
> usb 6-1: new full speed USB device using uhci_hcd and address 2
> usb 6-1: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver usbserial
> usbserial: USB Serial Driver core
> USB Serial support registered for pl2303
> pl2303 6-1:1.0: pl2303 converter detected
> usb 6-1: pl2303 converter now attached to ttyUSB0
> usbcore: registered new interface driver pl2303
> pl2303: Prolific PL2303 USB to serial adaptor driver
> hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
> usb 6-1: USB disconnect, address 2
> pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> pl2303 6-1:1.0: device disconnected
> usb 6-1: new full speed USB device using uhci_hcd and address 3
> usb 6-1: configuration #1 chosen from 1 choice
> pl2303 6-1:1.0: pl2303 converter detected
> usb 6-1: pl2303 converter now attached to ttyUSB1
> hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
> usb 6-1: USB disconnect, address 3
> pl2303 ttyUSB1: pl2303 converter now disconnected from ttyUSB1
> pl2303 6-1:1.0: device disconnected
> usb 6-1: new full speed USB device using uhci_hcd and address 4
> usb 6-1: configuration #1 chosen from 1 choice
> pl2303 6-1:1.0: pl2303 converter detected
> usb 6-1: pl2303 converter now attached to ttyUSB2
> 
> Then after two hours, while exiting from minicom (most probably):
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)

This will be fixed in the 2.6.30.1 release in a few hours.

thanks,

greg k-h
