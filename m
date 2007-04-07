Return-Path: <linux-kernel-owner+w=401wt.eu-S965122AbXDGChQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbXDGChQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 22:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965116AbXDGChQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 22:37:16 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:23470 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122AbXDGChO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 22:37:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGygFkZKhRO4UGdsb2JhbACPcgEBGyM
From: Dmitry Torokhov <dtor@insightbb.com>
To: Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
Date: Fri, 6 Apr 2007 22:37:12 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <20070407005458.GA18985@aitel.hist.no>
In-Reply-To: <20070407005458.GA18985@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704062237.13118.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 20:54, Helge Hafting wrote:
> I have an usb  touchscreen (egalax variety) that works with
> the 2.6.18 kernel supplied by debian.
> 
> It fails when I compile 2.6.21-rc5-mm4, tuned to the machine
> in question.  Unlike the debian kernel, this kernel don't use
> modules in order to save boot time.
> 
> The strange thing is, 2.6.21-rc5-mm4 recognizes the device.
> dmesg says things like 
> usb 3-2: Manufacturer: eGalac Inc.
> usb 3-2: Product: USB TouchController
> 
> and a lot more. Unlike 2.6.18, it never gets around to say
> "usbcore: registered new driver usbtouchscreen"
> which seems to indicate a problem.
> usbcore registers several other drivers, such as usbserial and pl2303
> that makes the gps work. It also registers other drivers like
> usb-storage,usbfs,hub,libusual,hiddev,usbhid.  But not usbtouchscreen.
> I believe I have turned on every config option for usb touchscreen,
> this should not be missing.
> 
> Is there something wrong, or could there be a seemingly unrelated option
> that I need to turn on?

Please make sure that you have CONFIG_USB_TOUCHSCREEN turned on.

-- 
Dmitry
