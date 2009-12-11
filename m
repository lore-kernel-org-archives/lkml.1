Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbZLKEyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbZLKEyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbZLKEf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:35:59 -0500
Received: from kroah.org ([198.145.64.141]:52876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759008AbZLKEfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:39 -0500
Date: Thu, 10 Dec 2009 20:35:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/90] 2.6.31.8-stable review
Message-ID: <20091211043502.GA17916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.31.8 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Yes, there are still more patches to be queued up for the .31-stable
tree, but as I just queued up 86 ext4 patches, I figured I would add 4
more to make it a nice even 90 and push it out for everyone to enjoy
while I work on getting the rest out after this.

Responses should be made by Sunday, Dec 13 04:00:00 UTC 2009
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.31.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/filesystems/ext4.txt   |   10 +-
 drivers/scsi/hosts.c                 |   13 +-
 drivers/scsi/lpfc/lpfc_init.c        |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c |    8 +-
 drivers/scsi/qla2xxx/qla_attr.c      |    3 +-
 drivers/scsi/scsi_lib_dma.c          |    4 +-
 fs/ext4/balloc.c                     |    8 +-
 fs/ext4/block_validity.c             |    2 +-
 fs/ext4/ext4.h                       |  105 +++++-
 fs/ext4/ext4_extents.h               |    7 +-
 fs/ext4/ext4_jbd2.c                  |    9 +-
 fs/ext4/ext4_jbd2.h                  |   27 ++-
 fs/ext4/extents.c                    |  493 +++++++++++++++++++++---
 fs/ext4/fsync.c                      |   54 ++--
 fs/ext4/inode.c                      |  705 +++++++++++++++++++++++++++++-----
 fs/ext4/ioctl.c                      |   32 +-
 fs/ext4/mballoc.c                    |  322 ++++++++--------
 fs/ext4/migrate.c                    |   28 +-
 fs/ext4/move_extent.c                |  572 ++++++++++++++++------------
 fs/ext4/namei.c                      |   47 +--
 fs/ext4/resize.c                     |    2 +-
 fs/ext4/super.c                      |  239 ++++++++----
 fs/ext4/xattr.c                      |   22 +-
 fs/jbd2/commit.c                     |    4 +
 fs/jbd2/journal.c                    |   11 +
 fs/jbd2/transaction.c                |    7 +-
 include/linux/sched.h                |   13 +-
 include/scsi/osd_protocol.h          |    1 +
 include/scsi/scsi_host.h             |   16 +-
 include/trace/events/ext4.h          |   60 +++-
 30 files changed, 2082 insertions(+), 744 deletions(-)
