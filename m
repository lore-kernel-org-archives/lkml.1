Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbYBZO6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbYBZO6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYBZO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:58:34 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59299 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbYBZO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:58:33 -0500
Date: Tue, 26 Feb 2008 09:58:32 -0500
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: Jiri Kosina <jkosina@suse.cz>, elendil@planet.nl,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
Message-ID: <20080226145832.GA1289@csclub.uwaterloo.ca>
References: <1203123219.6176.36.camel@popeye> <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz> <1203163503.6124.5.camel@popeye> <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz> <1203221372.6124.29.camel@popeye> <Pine.LNX.4.64.0802211036580.30955@jikos.suse.cz> <1203587101.27355.4.camel@popeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203587101.27355.4.camel@popeye>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 03:45:00AM -0600, Chris Holvenstot wrote:
> Jiri - 
> 
> I am tempted to lie to you and say it was in both modes, or when running
> under X only, but to tell you the truth while I have not seen it while
> running in console mode, I have not spent enough time there to make a
> solid statement one way or the other.

Hmm, I have been seeing repeated keys a lot under X on my athlon 700,
but mainly when I have firefox running (which is of course quite a load
on the poor old thing).  This has been going on for probably the last
year or so.  I thought it was just the machine getting weird, although
whenever it wasn't running firefox or other memory/cpu heavy loads it
seemed fine.

The USB bus also keeps detecting and loosing a USB hub again and again,
so perhaps that is also a software problem and not actually the hardware
failing.

For example I continuously get this:

usb-storage: device found at 84
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
usb 1-1: USB disconnect, address 82
usb 1-1.1: USB disconnect, address 83
usb 1-1.1.1: USB disconnect, address 84
usb 2-2: USB disconnect, address 44
usb 2-2: new full speed USB device using uhci_hcd and address 45
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
usb 1-1: new full speed USB device using uhci_hcd and address 85
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
usb 1-1.1: new full speed USB device using uhci_hcd and address 86
usb 1-1.1: configuration #1 chosen from 1 choice
hub 1-1.1:1.0: USB hub found
usb 1-1.1.1: new full speed USB device using uhci_hcd and address 87
usb 1-1.1.1: configuration #1 chosen from 1 choice
scsi20 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 87
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
usb 1-1: USB disconnect, address 85
usb 1-1.1: USB disconnect, address 86
usb 1-1.1.1: USB disconnect, address 87
usb 1-1: new full speed USB device using uhci_hcd and address 88
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
usb 1-1.1: new full speed USB device using uhci_hcd and address 89
usb 1-1.1: configuration #1 chosen from 1 choice
hub 1-1.1:1.0: USB hub found
usb 1-1.1.1: new full speed USB device using uhci_hcd and address 90
usb 1-1.1.1: configuration #1 chosen from 1 choice
scsi21 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 90
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
usb 1-1: USB disconnect, address 88
usb 1-1.1: USB disconnect, address 89
usb 1-1.1.1: USB disconnect, address 90
usb 2-2: USB disconnect, address 45
usb 2-2: new full speed USB device using uhci_hcd and address 46
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found

I have never checked if it stops doing that when firefox and such
isn't running and the keyboard isn't repeating characters.

I wonder if my keyboard problems started around 2.6.18 or earlier than
that or later.  I should try booting an older kernel again if I can make
it and see if it changes.

--
Len Sorensen
