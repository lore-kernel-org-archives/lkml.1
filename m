Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbZJMQGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbZJMQGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760458AbZJMQGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:06:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759948AbZJMQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:06:33 -0400
Date: Tue, 13 Oct 2009 09:05:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: eschvoca <eschvoca@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB regression: devices not initially recognized
Message-Id: <20091013090523.8ccb0598.akpm@linux-foundation.org>
In-Reply-To: <2b05065b0910100709h38cd4245p1c75c1f2207ee68f@mail.gmail.com>
References: <2b05065b0910100709h38cd4245p1c75c1f2207ee68f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb)

On Sat, 10 Oct 2009 10:09:13 -0400 eschvoca <eschvoca@gmail.com> wrote:

> Hi,
> 
> Using the Karmic beta of Ubuntu (linux-image-2.6.31-11-generic) my USB
> keyboard and blutooth dongle no longer work on bootup.  If I unplug
> them and plug them back in then it works.  I reported 

I which kernel version _did_ it work?

> the bug here:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/445160
> 
> which contains:
> 
> """
> Hi,
> 
> When booting into Karmic my Blutooth USB dongle and USB to PS2
> keyboard adapter are not recognized until I unplug them and plug them
> back in. In my dmesg (see attachment for the full version) I get error
> messages like:
> 
> [ 3.028029] usb 7-1: new full speed USB device using uhci_hcd and address 2
> [ 3.148023] usb 7-1: device descriptor read/64, error -71
> [ 3.372524] usb 7-1: device descriptor read/64, error -71
> [ 3.588019] usb 7-1: new full speed USB device using uhci_hcd and address 3
> [ 3.708018] usb 7-1: device descriptor read/64, error -71
> [ 3.936027] usb 7-1: device descriptor read/64, error -71
> [ 4.153513] usb 7-1: new full speed USB device using uhci_hcd and address 4
> [ 4.564074] usb 7-1: device not accepting address 4, error -71
> [ 4.676023] usb 7-1: new full speed USB device using uhci_hcd and address 5
> [ 5.088023] usb 7-1: device not accepting address 5, error -71
> [ 5.088042] hub 7-0:1.0: unable to enumerate USB device on port 1
> 
> My USB mouse and USB sound card are correctly identified on boot-up.
> Everything works fine in 9.04 so this seems like a regression.
> 
> Here is my lsusb after replugging the devices in:
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 007: ID 046d:c216 Logitech, Inc. Dual Action Gamepad
> Bus 001 Device 006: ID 08bb:2704 Texas Instruments Japan
> Bus 001 Device 005: ID 06b4:1c70
> Bus 001 Device 003: ID 0424:a700 Standard Microsystems Corp.
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 003: ID 058f:6362 Alcor Micro Corp. Hi-Speed 21-in-1
> Flash Card Reader/Writer (Internal/External)
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 005 Device 003: ID 0e8f:0020 GreenAsia Inc.
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 034: ID 0c10:0000
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 003: ID 0461:4d15 Primax Electronics, Ltd Dell Optical Mouse
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> And full dmesg is attached.
> 
> Let me know if I can test anything out.
> 
> Thanks.
> """
> 
> Any suggestions on how to track down the problem?
> 
