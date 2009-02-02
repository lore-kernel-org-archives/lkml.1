Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbZBBWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbZBBWe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZBBWet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:34:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZBBWes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:34:48 -0500
Date: Mon, 2 Feb 2009 14:28:38 -0800
From: Greg KH <gregkh@suse.de>
To: Miles Lane <miles.lane@gmail.com>, linux-usb@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/storage/transport.c:584
	last_sector_hacks+0x103/0x165 [usb_storage]()
Message-ID: <20090202222838.GB14147@suse.de>
References: <a44ae5cd0902021344q7cc1dcf7n8df03147f9115a42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0902021344q7cc1dcf7n8df03147f9115a42@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 04:44:08PM -0500, Miles Lane wrote:
> scsi7 : SCSI emulation for USB Mass Storage devices
> drivers/usb/core/inode.c: creating file '003'
> usb-storage: device found at 3
> usb-storage: waiting for device to settle before scanning
> scsi 7:0:0:0: Direct-Access     SanDisk  Cruzer           7.01 PQ: 0 ANSI: 0 CCS
> sd 7:0:0:0: [sdc] 15695871 512-byte hardware sectors: (8.03 GB/7.48 GiB)
> sd 7:0:0:0: [sdc] Write Protect is off
> sd 7:0:0:0: [sdc] Mode Sense: 45 00 00 08
> sd 7:0:0:0: [sdc] Assuming drive cache: write through
> sd 7:0:0:0: [sdc] 15695871 512-byte hardware sectors: (8.03 GB/7.48 GiB)
> sd 7:0:0:0: [sdc] Write Protect is off
> sd 7:0:0:0: [sdc] Mode Sense: 45 00 00 08
> sd 7:0:0:0: [sdc] Assuming drive cache: write through
>  sdc: sdc1
> sd 7:0:0:0: [sdc] Attached SCSI removable disk
> sd 7:0:0:0: Attached scsi generic sg4 type 0
> scsi 7:0:0:1: CD-ROM            SanDisk  Cruzer           7.01 PQ: 0 ANSI: 0
> sr2: scsi3-mmc drive: 48x/48x tray
> sr 7:0:0:1: Attached scsi CD-ROM sr2
> sr 7:0:0:1: Attached scsi generic sg5 type 5
> usb-storage: device scan complete
> usb 5-2:1.0: uevent
> usb 5-2: uevent
> usb 5-2:1.0: uevent
> usb 5-2: uevent
> ------------[ cut here ]------------
> WARNING: at drivers/usb/storage/transport.c:584
> last_sector_hacks+0x103/0x165 [usb_storage]()
> Hardware name: MT6821
> sdc: Successful last sector success at 15695870, device 0781:5406:0200

Thanks, we'll be removing this warning soon.

greg k-h
