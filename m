Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0BWVQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:16:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40373 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0BWVQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:16:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?iso-8859-1?q?=C1kos_Mar=F3y?= <akos@maroy.hu>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
Date: Tue, 23 Feb 2010 22:17:19 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <4B839202.8090008@maroy.hu>
In-Reply-To: <4B839202.8090008@maroy.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002232217.19201.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010, Ákos Maróy wrote:
> Hi,
> 
> I wonder if this is the write place to post this issue to, but I have a
> proplem when trying go suspend or hibernate my system. after enabling
> pm_trace by:
> 
> echo 1 > /sys/power/pm_trace
> 
> and then issuing pm-suspend, I get the following in dmesg:
> 
> [  685.833275] PM: Entering mem sleep
> [  685.833292] Suspending console(s) (use no_console_suspend to debug)
> [  685.993399] pm_op(): usb_dev_suspend+0x0/0x10 returns -2
> [  685.993404] PM: Device usb2 failed to suspend: error -2
> [  685.993408] PM: Some devices failed to suspend
> [  685.997009] PM: resume devices took 0.000 seconds
> [  685.997169] PM: Finishing wakeup.
> 
> this is on 2.6.32.8, but on 2.6.33-rc8 I get the same results.
> 
> trying to find out what device this is:
> 
> $ lsusb
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 003: ID 0bda:0159 Realtek Semiconductor Corp.
> Bus 001 Device 004: ID 04f2:b16c Chicony Electronics Co., Ltd
> Bus 001 Device 005: ID 03f0:231d Hewlett-Packard
> Bus 001 Device 002: ID 8087:0020
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> 
> my persumption is that "Device usb2" would be device 002 on bus 001
> above, that is, 8087:0020. googling for this USB id I found some
> references here: http://forum.notebookreview.com/showthread.php?p=5906076 :
> 
> Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> 
> 
> I wonder what could be done to make this device not sabotage the suspend
> process?

That's a good question for the USB people (CCed).

Rafael
