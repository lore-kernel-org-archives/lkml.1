Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYAWWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYAWWSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYAWWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:18:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33842 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751085AbYAWWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:18:09 -0500
Date: Wed, 23 Jan 2008 17:18:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Otavio Salvador <otavio@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB looks to be restarting
In-Reply-To: <20080123140330.1ca429c9.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0801231716460.6786-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Andrew Morton wrote:

> (cc linux-usb)
> 
> > On Tue, 15 Jan 2008 13:40:38 -0200 Otavio Salvador <otavio@debian.org> wrote:
> > Hello,
> > 
> > I have the following in my syslog:
> > 
> > Jan 15 13:30:38 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 5
> > Jan 15 13:30:38 neumann kernel: usb 5-2: new low speed USB device using uhci_hcd and address 14
> > Jan 15 13:30:39 neumann kernel: usb 5-2: configuration #1 chosen from 1 choice
> > Jan 15 13:30:39 neumann kernel: input: PS/2+USB Mouse as /class/input/input6
> > Jan 15 13:30:39 neumann kernel: input,hidraw2: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:1d.1-2
> > Jan 15 13:30:39 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 6
> > Jan 15 13:30:40 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 9
> > Jan 15 13:30:40 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 10
> > Jan 15 13:30:42 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 13
> > Jan 15 13:30:44 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 20
> > Jan 15 13:30:44 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 21
> > Jan 15 13:30:45 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 23
> > Jan 15 13:30:46 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 26
> > Jan 15 13:30:46 neumann kernel: usb 1-2: device descriptor read/64, error -71
> > Jan 15 13:30:47 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 27
> > Jan 15 13:30:48 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 28
> > Jan 15 13:30:48 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 29
> > Jan 15 13:30:49 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 30
> > Jan 15 13:30:50 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 32
> > Jan 15 13:30:50 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 33
> > Jan 15 13:30:52 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 39
> > Jan 15 13:30:54 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 45
> > Jan 15 13:30:56 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 53
> > Jan 15 13:30:57 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 58
> > Jan 15 13:31:00 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 68
> > Jan 15 13:31:02 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 75
> > Jan 15 13:31:02 neumann kernel: usb 1-2: device descriptor read/64, error -71
> > Jan 15 13:31:04 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 83
> > Jan 15 13:31:05 neumann kernel: usb 1-2: device descriptor read/64, error -71
> > Jan 15 13:31:05 neumann kernel: usb 1-2: device descriptor read/64, error -71
> > Jan 15 13:31:05 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 84
> > Jan 15 13:31:05 neumann kernel: usb 1-2: device descriptor read/64, error -71
> > Jan 15 13:31:05 neumann kernel: usb 1-2: device descriptor read/64, error -71
> > Jan 15 13:31:06 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 85
> > Jan 15 13:31:06 neumann kernel: usb 1-2: device not accepting address 85, error -71
> > Jan 15 13:31:06 neumann kernel: usb 1-2: new full speed USB device using uhci_hcd and address 86
> > Jan 15 13:31:06 neumann kernel: usb 1-2: device not accepting address 86, error -71
> > 
> > This happens with 2.6.23 and 2.6.24-rc7 kernels. (didn't test it with
> > previous release since this motherboard isn't well supported by them).
> > 
> > Does someone has any idea how to solve it?

Unplug the device attached to port 2 of bus 1.  Apparently it is 
spontaneously disconnecting and reconnecting itself over and over.

Alan Stern

