Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZAJVFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZAJVFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZAJVFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:05:34 -0500
Received: from SouthBend-74.pgzn.com ([206.212.253.74]:30095 "EHLO
	southbend-74.pgzn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:05:34 -0500
Subject: USB memory card reader and 64MB SD card - 2.6.28-git14
From: rhubbell <rhubbell@ihubbell.com>
Reply-To: RHubbell@ihubbell.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: iHubbell.com
Date: Sat, 10 Jan 2009 13:05:30 -0800
Message-Id: <1231621530.4495.36.camel@127>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - southbend-74.pgzn.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ihubbell.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me in replie,s if it's not too much trouble.)

I had this issue with previous kernels, but I don't know when the
problem
started. I once was able to read this card.

Not sure what filesystems are on either card, not sure if it matters.
The cards are not mounted automatically so I am guessing that the
file system doesn't become an issue until mount time.

The device is a Phison 6-in-1 and has no problems with
other cards.

When inserted this card causes no problems:

This is a 128MB card:

Jan 10 10:47:06  kernel:  uba: uba1


When the next card is inserted the keyboard partially locks up, the
special laptop keys work still.
e.g. the fn-contrast up/dn works still but not other keys work

Removing the card returns things to as before insertion.

This is a 64MB card from a phone:

Jan 10 10:54:44  kernel:  ubc: ubc1
Jan 10 10:54:44  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:54:51  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:54:52  kernel: __ratelimit: 22 callbacks suppressed
Jan 10 10:55:00  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:55:16  kernel:  ubc: ubc1
Jan 10 10:55:16  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:55:23  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:55:24  kernel: __ratelimit: 9 callbacks suppressed
Jan 10 10:55:32  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:55:56  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:56:44  kernel:  ubc: ubc1
Jan 10 10:56:44  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:56:51  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4
Jan 10 10:56:52  kernel: __ratelimit: 22 callbacks suppressed
Jan 10 10:57:00  kernel: usb 3-1: reset full speed USB device using
ohci_hcd and address 4

lspci:

00:02.0 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
00:02.1 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
00:02.2 USB Controller: nVidia Corporation nForce3 USB 2.0 (rev a2)


