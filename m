Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYDCN5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYDCN5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYDCN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:57:11 -0400
Received: from rtr.ca ([76.10.145.34]:1067 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbYDCN5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:57:10 -0400
Message-ID: <47F4E234.9000308@rtr.ca>
Date: Thu, 03 Apr 2008 09:57:08 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ASUS ScreenDuo
References: <1207230481.24037.11.camel@skunk.anacadf.mentorg.com>
In-Reply-To: <1207230481.24037.11.camel@skunk.anacadf.mentorg.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> Hi,
> 
> I have an ASUS motherboard with an USB gadget, the ASUS ScreenDUO. It's
> an independant little lcd screen with buttons, apparently it runs some
> kind of OS because it can access the net (e.g. to retrieve RSS) even
> when the computer is off - I guess they mean soft-off.
> 
> Well, all that is theory because it's under Vista, which I don't have.
> Under Linux the ScreenDUO is kind-of recognized: it says it's a mass
> storage device, but I can't mount it (the kernel says it's bound to sdc,
> but sdc doesn't exist).
> I'd like to access it. Does anyone know how that thing works ?
> 
> Thanks,
> 	Xav
> 
> PS: please Cc: me on anwers
> 
> interesting dmesg part:
> 
> usb 7-4: new high speed USB device using ehci_hcd and address 3
> usb 7-4: configuration #1 chosen from 1 choice
> scsi9 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 3
> usb-storage: waiting for device to settle before scanning
> usb-storage: device scan complete
> scsi 9:0:0:0: Direct-Access     ASUS     ScreenDUO             PQ: 0 ANSI: 2
> sd 9:0:0:0: [sdc] Attached SCSI removable disk
> usb 7-4: USB disconnect, address 3
> usb 7-4: new high speed USB device using ehci_hcd and address 4
> usb 7-4: configuration #1 chosen from 1 choice
> scsi10 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 4
> usb-storage: waiting for device to settle before scanning
> usb-storage: device scan complete
> scsi 10:0:0:0: Direct-Access     ASUS     ScreenDUO             PQ: 0 ANSI: 2
> sd 10:0:0:0: [sdc] Attached SCSI removable disk
> 
> 
> [root@awak:~]$ fdisk /dev/sdc
> 
> Unable to open /dev/sdc
> 
..

As root, try:   mknod /tmp/sdc b 8 32 ; fdisk /tmp/sdc

Any different?
