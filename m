Return-Path: <linux-kernel-owner+w=401wt.eu-S1423023AbXDTHGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423023AbXDTHGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423025AbXDTHGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:06:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:51060 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423023AbXDTHGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:06:52 -0400
Date: Fri, 20 Apr 2007 09:06:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       edouard.tisserant@wanadoo.fr, svoltz@numericable.fr
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
In-Reply-To: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Giuseppe Bilotta wrote:

> The first problem is that the usbmouse and usbhid drivers take control 
> of the device, so that when I plug it in the tablet appears as a mouse, 
> with extremely funny effects (cursor jumping around, buttons clicking 
> out of nowhere, and other strange stuff).I have to rmmod usbmouse and 
> usbhid and then re-modprobe acecad to get proper data from the tablet 
> (where by 'proper' I mean that input-events reports apparently correct 
> values for X, Y, pressure and keypresses.

Hi Giuseppe,

could you please send me the product ID of the hardware in question? (you 
could get it for example by running lsusb). Currently the usbhid driver 
blacklists just product ids 0x0004 and 0x0008 (so that for these product 
ids, the HID driver doesn't claim the device and lets other driver - 
acecad - to claim it). I guess you have some newer version of the device, 
so just adding it to blacklist should suffice.

Thanks,

-- 
Jiri Kosina
SUSE Labs
