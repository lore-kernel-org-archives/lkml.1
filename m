Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbZLKF3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbZLKF3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZLKF3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:29:05 -0500
Received: from kroah.org ([198.145.64.141]:53417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZLKF3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:02 -0500
Date: Thu, 10 Dec 2009 21:28:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/34] 2.6.32.1-stable review
Message-ID: <20091211052858.GA23229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.1 release.
There are 34 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

As was done with the 2.6.31.8-rc1 release, this is not all of the
patches in the -stable queue, just a huge chunk of ext4 patches here,
and a few scsi ones, which should all get out sooner rather than later.
So note that there will be more 2.6.32-stable releases coming, this is
just the first in the series.

Responses should be made by Sunday, Dec 13 04:00:00 UTC 2009
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/filesystems/ext4.txt   |   10 +-
 Makefile                             |    2 +-
 drivers/scsi/hosts.c                 |   13 ++-
 drivers/scsi/lpfc/lpfc_init.c        |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c |    8 +-
 drivers/scsi/qla2xxx/qla_attr.c      |    3 +-
 drivers/scsi/scsi_lib_dma.c          |    4 +-
 fs/ext4/balloc.c                     |    8 +-
 fs/ext4/block_validity.c             |    2 +-
 fs/ext4/ext4.h                       |    8 +
 fs/ext4/ext4_jbd2.h                  |   21 +++-
 fs/ext4/extents.c                    |   22 ++-
 fs/ext4/fsync.c                      |   54 +++----
 fs/ext4/inode.c                      |   81 +++++++---
 fs/ext4/ioctl.c                      |   29 +++--
 fs/ext4/mballoc.c                    |   40 ++++-
 fs/ext4/migrate.c                    |    4 +-
 fs/ext4/move_extent.c                |  278 ++++++++++++++++------------------
 fs/ext4/namei.c                      |   38 ++---
 fs/ext4/resize.c                     |    2 +-
 fs/ext4/super.c                      |   40 ++++--
 fs/ext4/xattr.c                      |    7 +-
 fs/jbd2/commit.c                     |    4 +
 fs/jbd2/journal.c                    |    5 +
 include/linux/sched.h                |   13 ++-
 include/scsi/osd_protocol.h          |    1 +
 include/scsi/scsi_host.h             |   16 ++-
 27 files changed, 424 insertions(+), 291 deletions(-)
