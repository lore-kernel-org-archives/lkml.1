Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0BWX7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 18:59:13 -0500
Received: from lucidpixels.com ([75.144.35.66]:33771 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0BWX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 18:59:12 -0500
Date: Tue, 23 Feb 2010 18:59:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel: 2.6.32.8 - usbfs: USBDEVFS_CONTROL failed
Message-ID: <alpine.DEB.2.00.1002231854410.8759@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel: 2.6.32.8

Using nut for my UPS.
Motherboard: Intel

The latest BIOS allows nut to work, but when the system is under load, I 
get this error:

BIOS: KGIBX10J

[34956.885638] usb 2-1.7: usbfs: USBDEVFS_CONTROL failed cmd usbhid-ups 
rqt 161 rq 1 len 4 ret -110
[36255.602870] usb 2-1.7: usbfs: USBDEVFS_CONTROL failed cmd usbhid-ups 
rqt 161 rq 1 len 4 ret -110

Feb 23 16:26:00 p34 upsd[2235]: Data for UPS [apc] is stale - check driver
Feb 23 16:26:00 p34 upsmon[2286]: Poll UPS [apc@localhost] failed - Data stale
Feb 23 16:26:00 p34 upsmon[2286]: Communications with UPS apc@localhost lost
Feb 23 16:26:02 p34 upsd[2235]: UPS [apc] data is no longer stale
Feb 23 16:26:30 p34 upsmon[2286]: Communications with UPS apc@localhost established

I tried increasing the intervals but I still get these errors, can someone 
please advise on where to go from here?  This _never_ occurred when using 
an OHCI USB card (VIA).

Thanks,

Justin

