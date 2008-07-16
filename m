Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYGPRn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYGPRn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYGPRnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:43:19 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:48248 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYGPRnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:43:18 -0400
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 13:43:18 EDT
Message-ID: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
Date: Wed, 16 Jul 2008 10:32:31 -0700 (PDT)
Subject: Problem mounting Motorola USB device
From: "Alan" <alan@clueserver.org>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
I have a Motorola phone that mounts as USB storage.  The phone used to
mount under 2.6.24 on Fedora 8.  Under the latest kernels, however, it
does not want to mount.  The device gives an odd media error at towards
the end of the device.  It gave that before, but would still mount.

Does anyone have an idea what is going wrong?

How can I mount the device anyway?  (The /dev/sdb does not get created by
usb-storage in this case.)  I know I probably need a new memory card.  I
would like to recover this one first.

Here are the /var/log/messages...

usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     Motorola Phone                 PQ: 0 ANSI: 4
sd 6:0:0:0: [sdb] 1987584 512-byte hardware sectors (1018 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 10 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] 1987584 512-byte hardware sectors (1018 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 10 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:0:0: [sdb] Sense Key : Medium Error [current]
sd 6:0:0:0: [sdb] Add. Sense: No additional sense information
end_request: I/O error, dev sdb, sector 1987576
