Return-Path: <linux-kernel-owner+w=401wt.eu-S1763101AbZCXU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763101AbZCXU0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbZCXU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:26:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41342 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbZCXUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jb4n1U/9xBd/J7QhNjOuAvDZIWm4JI6X20vbcWQuT/04nnnxpC+kSm++cUtCCq816z
         RJi6mpOnGczIITZyMmlMNoC+tsN4MoXdHyO0sXWFREz9R2tGHhSyAxVqaCD7wAGnDhQp
         bxw5JyTjVTtaK3E4yM9OMsybumrd9dCw7u5VY=
Message-ID: <49C941D5.1000509@gmail.com>
Date: Tue, 24 Mar 2009 22:25:57 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: 2.6.29: EXT4: __ext4_get_inode_loc errors after s2disk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After upgrading to 2.6.29 I get the below errors after resuming from
hibernating with s2disk. I ran fsck and tried doing the same thing again
in 2.6.28.9-pae, but do not get any errors there.

sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >

sd 0:0:0:0: [sda] Attached SCSI disk

EXT4-fs: barriers enabled
kjournald2 starting: pid 649, dev sda6:8, commit interval 5 seconds
EXT4 FS on sda6, internal journal on sda6:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem sda6 with ordered data mode
EXT4 (no)acl options not supported
Adding 2099328k swap on /dev/sda5.  Priority:-1 extents:1across:2099328k
EXT3 FS on sda7, internal journal
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Starting disk
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
sd 0:0:0:0: [sda] Add. Sense: No additional sense information
end_request: I/O error, dev sda, sector 242190447
EXT4-fs error (device sda6): __ext4_get_inode_loc: <6>sd 0:0:0:0: [sda]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
sd 0:0:0:0: [sda] unable to read inode block - inode=2346519,
block=9404418Add. Sense: No additional sense information end_request:
I/O error, dev sda, sector 242190703
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure

Any ideas?

Niel
