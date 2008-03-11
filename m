Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYCKCkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYCKCkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYCKCka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:40:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:1534 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYCKCk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b9EaYPf1qXkUWNQHZoxlCr6YBOpXTaQpmVXZ1RYSYscrr8gE44yVXYeEJdNzWnKGRV616WDZpp/ixu5Zp7hwtpPtORjOGzxph9E20gSU5YK2PERpzOdGEtKB3atRXqpJNd7WFYf5mRT9rYdOUaogfeIASRTeGnUPjsgQyF7ituY=
Message-ID: <a8e1da0803101940y55116080nb011d671294dd748@mail.gmail.com>
Date: Tue, 11 Mar 2008 10:40:28 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: 2.6.25-rc3 sometimes reboot with usb init(probe?) slowly
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0803102235110.30713-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311021314.GA3350@darkstar.te-china.tietoenator.com>
	 <Pine.LNX.4.44L0.0803102235110.30713-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 10:37 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 11 Mar 2008, Dave Young wrote:
>
>  > Hi,
>  > Sometimes (not every time) rebooting will be slow while initilize usb
>  > device
>  >
>  > This is not limited to 2.6.25-rc3.
>  >
>  > Please see the timing issue in following dmesg output:
>  >
>  > ---
>  ...
>
> > [    9.167129] usbcore: registered new interface driver hiddev
>  > [    9.182630] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input0
>  > [   64.677054] usb 1-1: USB disconnect, address 2
>  > [   64.677054] usb 1-1.3: USB disconnect, address 5
>  > [   64.678008] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-2
>  > [   64.693697] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input1
>  > [   64.713662] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.2-1
>  > [   64.713676] usbcore: registered new interface driver usbhid
>  > [   64.713676] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
>
>  More information is needed.  You should turn on CONFIG_USB_DEBUG.

Ok, but it only occurs "sometimes".  If I have new findings, I will
let you know.

>
>  Alan Stern
>
>
