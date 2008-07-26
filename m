Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbYGZGvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbYGZGvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYGZGvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:51:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbYGZGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:51:34 -0400
Date: Fri, 25 Jul 2008 23:51:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alan" <alan@clueserver.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Problem mounting Motorola USB device
Message-Id: <20080725235122.0e097f1f.akpm@linux-foundation.org>
In-Reply-To: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
References: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb-devel)

On Wed, 16 Jul 2008 10:32:31 -0700 (PDT) "Alan" <alan@clueserver.org> wrote:

> Initializing USB Mass Storage driver...
> scsi6 : SCSI emulation for USB Mass Storage devices
> I have a Motorola phone that mounts as USB storage.  The phone used to
> mount under 2.6.24 on Fedora 8.  Under the latest kernels, however, it
> does not want to mount.  The device gives an odd media error at towards
> the end of the device.  It gave that before, but would still mount.
> 
> Does anyone have an idea what is going wrong?
> 
> How can I mount the device anyway?  (The /dev/sdb does not get created by
> usb-storage in this case.)  I know I probably need a new memory card.  I
> would like to recover this one first.
> 
> Here are the /var/log/messages...
> 
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device found at 3
> usb-storage: waiting for device to settle before scanning
> usb-storage: device scan complete
> scsi 6:0:0:0: Direct-Access     Motorola Phone                 PQ: 0 ANSI: 4
> sd 6:0:0:0: [sdb] 1987584 512-byte hardware sectors (1018 MB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 10 00 00 00
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] 1987584 512-byte hardware sectors (1018 MB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 10 00 00 00
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
> sd 6:0:0:0: [sdb] Attached SCSI disk
> sd 6:0:0:0: Attached scsi generic sg2 type 0
> sd 6:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 6:0:0:0: [sdb] Sense Key : Medium Error [current]
> sd 6:0:0:0: [sdb] Add. Sense: No additional sense information
> end_request: I/O error, dev sdb, sector 1987576

It's a 2.6.24 -> 2.6.25 regression.
