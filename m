Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbYA2Nz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbYA2Nz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932358AbYA2NzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:55:07 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9408 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbYA2Nys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:54:48 -0500
Date: Tue, 29 Jan 2008 14:54:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080129135443.GU15220@kernel.dk>
References: <20080128204935.GI15220@kernel.dk> <20080128212114.GA15586@kroah.com> <479F18D3.9030709@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F18D3.9030709@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Boaz Harrosh wrote:
> Greg KH wrote:
> > On Mon, Jan 28, 2008 at 09:49:35PM +0100, Jens Axboe wrote:
> >> Hi,
> >>
> >> Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
> >> connecting my cf usb storage device yields and endless stream of:
> >>
> >> Initializing USB Mass Storage driver...
> >> scsi6 : SCSI emulation for USB Mass Storage devices
> >> usb-storage: device found at 2
> >> usb-storage: waiting for device to settle before scanning
> >> usbcore: registered new interface driver usb-storage
> >> USB Mass Storage support registered.
> >> scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
> >> ANSI: 0
> >> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
> >> sd 6:0:0:0: [sdb] Write Protect is off
> >> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
> >> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> >> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
> >> sd 6:0:0:0: [sdb] Write Protect is off
> >> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
> >> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> >>  sdb: sdb1
> >> sd 6:0:0:0: [sdb] Attached SCSI removable disk
> >> sd 6:0:0:0: Attached scsi generic sg1 type 0
> >> scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
> >> ANSI: 0
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> [...]
> >>
> >> until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
> >> I'm attaching boot messages and my .config.
> > 
> > That's a bit wierd, as we haven't added any USB patches to the -git tree
> > yet after 2.6.24 :)
> > 
> > Could this be caused by some scsi changes perhaps?
> > 
> > thanks,
> > 
> > greg k-h
> > -
> Yes it is ;)
> 
> Jens could you test the patch below? if it works I'll submit a proper
> patch. Please forgive me for the bug.

No difference, still just a lot of resets.

-- 
Jens Axboe

