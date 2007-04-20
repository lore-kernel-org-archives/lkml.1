Return-Path: <linux-kernel-owner+w=401wt.eu-S1767097AbXDTN2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767097AbXDTN2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767098AbXDTN2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:28:31 -0400
Received: from styx.suse.cz ([82.119.242.94]:38463 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767096AbXDTN2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:28:30 -0400
Date: Fri, 20 Apr 2007 15:35:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       edouard.tisserant@wanadoo.fr
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
In-Reply-To: <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz>
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com> 
 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
 <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Giuseppe Bilotta wrote:

> > could you please send me the product ID of the hardware in question? 
> > (you could get it for example by running lsusb). Currently the usbhid 
> > driver blacklists just product ids 0x0004 and 0x0008 (so that for 
> > these product ids, the HID driver doesn't claim the device and lets 
> > other driver - acecad - to claim it). I guess you have some newer 
> > version of the device, so just adding it to blacklist should suffice.
> lsusb claims:
> Bus 002 Device 003: ID 0460:0004 Ace Cad Enterprise Co., Ltd
> and according to hid-core.c this *is* a blacklisted ID ...

Yes, so it definitely should be ignored and not claimed by the usbhid 
subsystem.

Could you please verify in /sys/bus/usb/drivers/usbhid whether this device 
is really claimed by the usbhid driver? Do you have other HID devices in 
the system?

-- 
Jiri Kosina
