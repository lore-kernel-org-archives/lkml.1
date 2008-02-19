Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYBSQwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYBSQwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYBSQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:51:58 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51296 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbYBSQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:51:57 -0500
Date: Tue, 19 Feb 2008 17:51:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: hid device not claimed but /dev/input/event exists
In-Reply-To: <47BB041F.4060003@dbservice.com>
Message-ID: <Pine.LNX.4.64.0802191751040.7699@twin.jikos.cz>
References: <47BB041F.4060003@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Tomas Carnecky wrote:

> usb 1-2.2: new full speed USB device using ehci_hcd and address 6
> usb 1-2.2: configuration #1 chosen from 1 choice
> HID device claimed by neither input, hiddev nor hidraw
> input: Logitech Z-10 USB Speaker as
> /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2.2/1-2.2:1.3/input/input4
> input: USB HID v1.10 Device [Logitech Z-10 USB Speaker] on
> usb-0000:00:02.1-2.2
> Nobody claims the device and yet an evdev device shows up in /dev/input? That

Yes, that looks indeed bogus.

> I enabled HID_DEBUG, but no debug messages show up in my dmesg output, 
> which is strange. 

You have to modprobe the 'hid' module with 'debug=1' parameter. Please 
send me the resulting output.

-- 
Jiri Kosina
SUSE Labs

